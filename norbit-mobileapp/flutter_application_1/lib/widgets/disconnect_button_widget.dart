import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/connectivity/connectivity_state.dart';

class DisconnectButton extends StatelessWidget {
  final ConnectivityState state;

  const DisconnectButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: state is Connected
          ? () => context.read<ConnectivityBloc>().add(Disconnect())
          : null,
      style: ElevatedButton.styleFrom(primary: Colors.red),
      child: const Text('Disconnect'),
    );
  }
}
