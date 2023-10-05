import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
// import '../../blocs/connectivity/connectivity_state.dart';

class AccelerometerWidget extends StatelessWidget {
  final AccelerometerEvent? accelerometerEvent;

  const AccelerometerWidget({super.key, required this.accelerometerEvent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('x: ${accelerometerEvent!.x.toStringAsFixed(2)} m/s²'),
        Text('y: ${accelerometerEvent!.y.toStringAsFixed(2)} m/s²'),
        Text('z: ${accelerometerEvent!.z.toStringAsFixed(2)} m/s²'),
      ],
    );
  }
}
