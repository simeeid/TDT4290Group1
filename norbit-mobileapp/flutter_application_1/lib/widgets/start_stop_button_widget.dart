import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/connectivity/connectivity_state.dart';

class StartStopButton extends StatelessWidget {
  final ConnectivityState state;

  const StartStopButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: state is Connected
          ? () async {
              if (await Permission.microphone.request().isGranted) {
                context.read<ConnectivityBloc>().add(StartStop());
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
          primary: state is DataStarted ? Colors.red : Colors.green),
      child: Text(state is DataStarted ? 'Stop' : 'Start'),
    );
  }
}
