import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/connectivity/location_bloc.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';
import 'package:flutter_application_1/widgets/connectivity_textfield_widget.dart';
import 'package:flutter_application_1/widgets/sensors/accelerometer_widget.dart';
import 'package:flutter_application_1/widgets/sensors/location_widget.dart';
import 'package:flutter_application_1/widgets/sensors/lux_widget.dart';
import 'package:flutter_application_1/widgets/sensors/noise_widget.dart';
import 'package:flutter_application_1/widgets/start_stop_button_widget.dart';
import 'package:provider/provider.dart';
import '../blocs/connectivity/noise_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/accelerometer_bloc.dart';
import '../blocs/start_stop_bloc.dart';
import '../services/location_service.dart';
import '../widgets/sensor_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noiseBloc = Provider.of<NoiseBloc>(context);
    final luxBloc = Provider.of<LuxBloc>(context);
    final accelerometerBloc = Provider.of<AccelerometerBloc>(context);
    final locationBloc = Provider.of<LocationBloc>(context);
    final locationService = Provider.of<LocationService>(context, listen: false);
    final noiseService = Provider.of<NoiseService>(context, listen: false);
    final luxService = Provider.of<LuxService>(context, listen: false);
    final accelerometerService = Provider.of<AccelerometerService>(context, listen: false);
    final startStopBloc = Provider.of<StartStopBloc>(context);

    return StreamBuilder<bool>(
      stream: startStopBloc.startStopController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Norbit mobile app'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: 200.0,
                        child: StartStopButton(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (snapshot.data == true)
                      Column(
                        children: [
                          SensorWidget(
                            title: 'Accelerometer',
                            child: AccelerometerWidget(accelerometerBloc: accelerometerBloc),
                          ),
                          const SizedBox(height: 16),
                          SensorWidget(
                            title: 'Light sensor',
                            child: LuxWidget(luxBloc: luxBloc),
                          ),
                          const SizedBox(height: 16),
                          SensorWidget(
                            title: 'Noisemeter',
                            child: NoiseWidget(noiseBloc: noiseBloc),
                          ),
                          const SizedBox(height: 16),
                          SensorWidget(
                            title: 'GPS',
                            child: LocationWidget(locationBloc: locationBloc),
                          ),
                        ],
                      ),
                  ],
                ),
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
