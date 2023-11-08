import 'dart:convert';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/device_name_bloc.dart';
import '../blocs/token_bloc.dart';
import '../blocs/username_bloc.dart';
import '../services/aws_service.dart';
import '../services/save_service.dart';

class RegisterDevicePopupWrapper extends StatelessWidget {
  final UsernameBloc usernameBloc;
  final TokenBloc tokenBloc;
  final DeviceNameBloc deviceNameBloc;

  const RegisterDevicePopupWrapper({
    super.key,
    required this.usernameBloc,
    required this.tokenBloc,
    required this.deviceNameBloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: usernameBloc.usernameController,
      builder: (context, snapshotUsername) {
        return StreamBuilder<String>(
          stream: tokenBloc.tokenController,
          builder: (context, snapshotToken) {
            return StreamBuilder<String>(
              stream: deviceNameBloc.deviceNameStream,
              builder: (context, snapshotDeviceName) {
                return RegisterDevicePopup(
                  username: snapshotUsername.data!,
                  token: snapshotToken.data!,
                  deviceName: snapshotDeviceName.data,
                  deviceNameBloc: deviceNameBloc,
                );
              },
            );
          },
        );
      },
    );
  }
}

class RegisterDevicePopup extends StatelessWidget {
  final String username;
  final String token;
  final String? deviceName;
  final DeviceNameBloc deviceNameBloc;

  RegisterDevicePopup({
    Key? key,
    required this.username,
    required this.token,
    this.deviceName,
    required this.deviceNameBloc,
  }) : super(key: key);

  final TextEditingController _deviceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Register Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Enter a name for your device:'),
          const SizedBox(height: 10),
          TextField(
            controller: _deviceNameController,
            decoration: const InputDecoration(labelText: 'Device Name'),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            String deviceName = _deviceNameController.text;
            deviceNameBloc.addDeviceName(deviceName);
            final awsService = AwsService(token, username, deviceName);
            String awsCreds = await awsService.getCreds();
            final awsCredsMap = json.decode(awsCreds);
            final data = awsCredsMap['data'];
            final certificatePem = data['certificatePem'];
            final privateKey = data['privateKey'];
            final saveService = SaveService();
            await saveService.saveStringToFile(
                certificatePem, 'certificate.txt');
            await saveService.saveStringToFile(privateKey, 'privateKey.txt');
            await saveService.saveStringToFile(deviceName, 'deviceName.txt');
            _deviceNameController.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class DeviceName {
  final DeviceNameBloc deviceNameBloc;

  DeviceName({required this.deviceNameBloc});

  Future<bool> getDeviceName() async {
    try {
      final saveService = SaveService();
      final String? deviceName =
          await saveService.readStringFromFile('deviceName.txt');
      if (deviceName != null) {
        deviceNameBloc.addDeviceName(deviceName);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
