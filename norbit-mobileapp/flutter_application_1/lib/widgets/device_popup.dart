import 'package:flutter/material.dart';

class DevicePopup extends StatelessWidget {
  const DevicePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Device settings'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Enter a nickname for your device:'),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Device Nickname'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
