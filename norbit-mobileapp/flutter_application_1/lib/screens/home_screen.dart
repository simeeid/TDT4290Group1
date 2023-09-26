import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity/connectivity_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Norbit mobile app'),
      ),
      body: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    enabled: state is Disconnected,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: state is Disconnected
                            ? () =>
                                context.read<ConnectivityBloc>().add(Connect())
                            : null,
                        child: Text('Connect'),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: state is Connected
                            ? () => context
                                .read<ConnectivityBloc>()
                                .add(Disconnect())
                            : null,
                        child: Text('Disconnect'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: state is Connected
                        ? () =>
                            context.read<ConnectivityBloc>().add(StartStop())
                        : null,
                    child: Text(state is DataStarted ? 'Stop' : 'Start'),
                    style: ElevatedButton.styleFrom(
                        primary:
                            state is DataStarted ? Colors.red : Colors.green),
                  ),
                  SizedBox(height: 16.0),
                  if (state is DataUpdated)
                    Column(
                      children: [
                        Text('x: ${state.accelerometerEvent.x}'),
                        Text('y: ${state.accelerometerEvent.y}'),
                        Text('z: ${state.accelerometerEvent.z}'),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
