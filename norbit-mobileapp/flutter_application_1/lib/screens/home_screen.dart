import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';
import 'package:flutter_application_1/widgets/connectivity_textfield_widget.dart';
import 'package:flutter_application_1/widgets/sensors/accelerometer_widget.dart';
import 'package:flutter_application_1/widgets/sensors/lux_widget.dart';
import 'package:flutter_application_1/widgets/sensors/noise_widget.dart';
import 'package:flutter_application_1/widgets/start_stop_button_widget.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/noise_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/accelerometer_bloc.dart';
import '../blocs/start_stop_button_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noiseBloc = Provider.of<NoiseBloc>(context);
    final luxBloc = Provider.of<LuxBloc>(context);
    final accelerometerBloc = Provider.of<AccelerometerBloc>(context);
    final noiseService = Provider.of<NoiseService>(context, listen: false);
    final luxService = Provider.of<LuxService>(context, listen: false);
    final accelerometerService =
        Provider.of<AccelerometerService>(context, listen: false);
    final startStopBloc = Provider.of<StartStopBloc>(context);

    return StreamBuilder<bool>(
      stream: startStopBloc.startStopController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Norbit mobile app'),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Add padding for all elements
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ConnectivityTextField(),
                  const SizedBox(height: 16.0),
                  const Center(
                    child: SizedBox(
                      width:
                          200.0, // Set the desired width for the StartStopButton
                      child: StartStopButton(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (snapshot.data == true)
                    Column(
                      children: [
                        AccelerometerWidget(
                            accelerometerBloc: accelerometerBloc),
                        const SizedBox(height: 16.0),
                        LuxWidget(luxBloc: luxBloc),
                        const SizedBox(height: 16.0),
                        NoiseWidget(noiseBloc: noiseBloc),
                      ],
                    ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
