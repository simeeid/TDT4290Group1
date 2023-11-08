import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/noise_bloc.dart';

/*
NoiseWidget uses the data in the stream of the noise bloc.
It updates the noise data on the users screen based on this data.
It displays noise data in dB.
 */

class NoiseWidget extends StatelessWidget {
  final NoiseBloc noiseBloc;

  const NoiseWidget({Key? key, required this.noiseBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: noiseBloc.noiseController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Noise level: ${snapshot.data!.toStringAsFixed(2)} dB',
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
