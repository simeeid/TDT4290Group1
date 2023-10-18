import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';
import 'package:flutter_application_1/services/mqtt_service.dart';
import '../blocs/start_stop_bloc.dart';
import '../services/location_service.dart';

class StartStopButton extends StatelessWidget {

  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final noiseService = Provider.of<NoiseService>(context, listen: false);
    final luxService = Provider.of<LuxService>(context, listen: false);
    final accelerometerService = Provider.of<AccelerometerService>(context, listen: false);
    final startStopBloc = Provider.of<StartStopBloc>(context);
    final mqtt_service = Provider.of<MqttService>(context, listen: false);
    final locationService = Provider.of<LocationService>(context);
    return StreamBuilder<bool>(
      stream: startStopBloc.startStopController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ElevatedButton(
            onPressed: () async {
              if (snapshot.data == false) {
                luxService.start();
                accelerometerService.start();
                await noiseService.start();
                await locationService.determinePosition();
                locationService.start();
                startStopBloc.switchState(true);
                mqtt_service.connect();
                mqtt_service.publishNoiseData();
                mqtt_service.publishLuxData();
                mqtt_service.publishAccelerometerData();
              } else if (snapshot.data == true) {
                luxService.stop();
                accelerometerService.stop();
                noiseService.stop();
                locationService.stop();
                startStopBloc.switchState(false);
                mqtt_service.disconnect();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: snapshot.data! ? Colors.red : Colors.green),
            child: Text(snapshot.data! ? 'Stop' : 'Start'),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
