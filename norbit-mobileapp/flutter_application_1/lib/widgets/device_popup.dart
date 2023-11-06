import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/token_bloc.dart';
import '../blocs/connectivity/username_bloc.dart';
import '../services/aws_service.dart';

class DevicePopupWrapper extends StatelessWidget {
  final UsernameBloc usernameBloc;
  final TokenBloc tokenBloc;

  const DevicePopupWrapper(
      {super.key, required this.usernameBloc, required this.tokenBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: usernameBloc.usernameController,
      builder: (context, snapshotUsername) {
        return StreamBuilder<String>(
          stream: tokenBloc.tokenController,
          builder: (context, snapshotToken) {
            return DevicePopup(
              username: snapshotUsername.data!,
              token: snapshotToken.data!,
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

  DevicePopup({Key? key, required this.username, required this.token})
      : super(key: key);

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
          onPressed: () {
            Navigator.of(context).pop();

            String deviceId = _deviceNicknameController.text;

            final awsService = AwsService(token, username, deviceId);
            awsService.getCreds();

            _deviceNicknameController.clear();
            safePrint("YEY WE DID IT LOL");
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
