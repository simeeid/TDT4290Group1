import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';

class NoiseWidget extends StatelessWidget {
  final NoiseReading? noiseReading;

  const NoiseWidget({super.key, required this.noiseReading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Noise level: ${noiseReading!.meanDecibel.toStringAsFixed(2)} dB'),
      ],
    );
  }
}
