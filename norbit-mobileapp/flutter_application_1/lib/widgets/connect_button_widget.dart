import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/connectivity/connectivity_state.dart';

class ConnectButton extends StatelessWidget {
  final ConnectivityState state;

  const ConnectButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: state is Disconnected
          ? () => context.read<ConnectivityBloc>().add(Connect())
          : null,
      style: ElevatedButton.styleFrom(primary: Colors.green),
      child: const Text('Connect'),
    );
  }
}
