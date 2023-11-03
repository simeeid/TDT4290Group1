import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/mqtt_service.dart';

class DevicePopup extends StatelessWidget {
  DevicePopup({super.key});
  final TextEditingController _deviceNicknameController = TextEditingController();


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
            final mqttService = Provider.of<MqttService>(context, listen: false);

            // You can use the `deviceNickname` variable to access the user's input.
            String deviceNickname = _deviceNicknameController.text;

            // Add code here for registering the device

            _deviceNicknameController.clear();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}