import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/aws_service.dart';
import '../services/login_service.dart';

class DevicePopup extends StatelessWidget {
  DevicePopup({super.key});

  final TextEditingController _deviceNicknameController =
      TextEditingController();
  final loginService =
      Provider.of<LogInService>(context as BuildContext, listen: false);

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
            String username = loginService.username!;
            String token = loginService.idToken!;

            final awsService = AwsService(token, username, deviceId);
            awsService.getCreds();

            _deviceNicknameController.clear();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
