import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/connect_button_widget.dart';
import 'package:flutter_application_1/widgets/connectivity_textfield_widget.dart';
import 'package:flutter_application_1/widgets/disconnect_button_widget.dart';
import 'package:flutter_application_1/widgets/sensors/accelerometer_widget.dart';
import 'package:flutter_application_1/widgets/sensors/lux_widget.dart';
import 'package:flutter_application_1/widgets/sensors/noise_widget.dart';
import 'package:flutter_application_1/widgets/start_stop_button_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity/connectivity_bloc.dart';
import '../blocs/connectivity/connectivity_state.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/noise_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/accelerometer_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noiseBloc = Provider.of<NoiseBloc>(context);
    final luxBloc = Provider.of<LuxBloc>(context);
    final accelerometerBloc = Provider.of<AccelerometerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Norbit mobile app'),
      ),
      body: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConnectivityTextField(state: state),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ConnectButton(state: state),
                      DisconnectButton(state: state),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  StartStopButton(state: state),
                  const SizedBox(height: 16.0),
                  if (state is DataUpdated)
                    Column(
                      children: [
                        //if (state.accelerometerEvent != null)
                        AccelerometerWidget(
                            accelerometerBloc: accelerometerBloc),
                        //if (state.luxValue != null)
                        LuxWidget(luxBloc: luxBloc),
                        NoiseWidget(noiseBloc: noiseBloc),
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
