import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/device_name_bloc.dart';

/*
DeviceData displays basic data about the device.
Per now it is only device name, however other important device data shouls be added here.
 */

class DeviceDataWidget extends StatelessWidget {
  final DeviceNameBloc deviceNameBloc;

  const DeviceDataWidget({
    super.key,
    required this.deviceNameBloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: deviceNameBloc.deviceNameStream,
      builder: (context, snapshotDeviceName) {
        String deviceName = snapshotDeviceName.data ?? "N/A";
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Device Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text("Device Name: $deviceName"),
              ],
            ),
          ),
        );
      },
    );
  }
}
