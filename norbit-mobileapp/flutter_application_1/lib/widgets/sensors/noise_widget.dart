import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/noise_bloc.dart';

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
              Text('Noise level: ${snapshot.data!.toStringAsFixed(2)} dB',
                style: const TextStyle(fontSize: 20),),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
