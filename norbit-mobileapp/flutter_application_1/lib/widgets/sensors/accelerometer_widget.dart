import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/accelerometer_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

/*
AccelerometerWidget uses the data in the stream of the accelerometer bloc.
It updates the accelerometer data on the users screen based on this data.
It displays x, y and z in m/s^2
 */

class AccelerometerWidget extends StatelessWidget {
  final AccelerometerBloc accelerometerBloc;

  const AccelerometerWidget({Key? key, required this.accelerometerBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccelerometerEvent>(
      stream: accelerometerBloc.accelerometerStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'X: ${snapshot.data!.x.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Y: ${snapshot.data!.y.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Z: ${snapshot.data!.z.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
