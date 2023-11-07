import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/device_name_bloc.dart';
import '../blocs/connectivity/token_bloc.dart';
import '../blocs/connectivity/username_bloc.dart';
import '../services/aws_service.dart';
import '../services/save_service.dart';

class DevicePopupWrapper extends StatelessWidget {
  final UsernameBloc usernameBloc;
  final TokenBloc tokenBloc;
  final DeviceNameBloc deviceNameBloc;

  const DevicePopupWrapper({
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
                return DevicePopup(
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

class DevicePopup extends StatelessWidget {
  final String username;
  final String token;
  final String? deviceName;
  final DeviceNameBloc deviceNameBloc;

  DevicePopup({
    Key? key,
    required this.username,
    required this.token,
    this.deviceName,
    required this.deviceNameBloc,
  }) : super(key: key);

  final TextEditingController _deviceNicknameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Device settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Enter a nickname for your device:'),
          const SizedBox(height: 10),
          TextField(
            controller: _deviceNicknameController,
            decoration: const InputDecoration(labelText: 'Device Nickname'),
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();

            String deviceName = _deviceNicknameController.text;
            deviceNameBloc.addDeviceName(deviceName);
            final awsService = AwsService(token, username, deviceName);
            String awsCreds = await awsService.getCreds();
            final awsCredsMap = json.decode(awsCreds);
            final data = awsCredsMap['data'];
            final certificatePem = data['certificatePem'];
            final privateKey = data['privateKey'];
            final rootCA = data['rootCA'];
            final saveService = SaveService();
            await saveService.saveStringToFile(
                certificatePem, 'certificate.txt');
            await saveService.saveStringToFile(privateKey, 'privateKey.txt');
            await saveService.saveStringToFile(rootCA, 'rootCA.txt');

            _deviceNicknameController.clear();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
