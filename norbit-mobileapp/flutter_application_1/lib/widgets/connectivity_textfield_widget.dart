import 'package:flutter/material.dart';
import '../blocs/connectivity/connectivity_state.dart';

class ConnectivityTextField extends StatelessWidget {
  final ConnectivityState state;

  const ConnectivityTextField({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      enabled: state is Disconnected,
    );
  }
}
