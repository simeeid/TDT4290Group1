import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/connectivity/connectivity_state.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';

class StartStopButton extends StatelessWidget {
  final ConnectivityState state;

  const StartStopButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final noiseService = Provider.of<NoiseService>(context, listen: false);
    final luxService = Provider.of<LuxService>(context, listen: false);
    final accelerometerService = Provider.of<AccelerometerService>(context, listen: false);
    return ElevatedButton(
      onPressed: state is Connected
          ? () async {
        if (await Permission.microphone.request().isGranted) {
          context.read<ConnectivityBloc>().add(StartStop());
        }
        luxService.start();
        accelerometerService.start();
        await noiseService.start();
      }
          : null,
      style: ElevatedButton.styleFrom(
          primary: state is DataStarted ? Colors.red : Colors.green),
      child: Text(state is DataStarted ? 'Stop' : 'Start'),
    );
  }
}
