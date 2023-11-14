import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/sensors/noise_service.dart';
import 'package:flutter_application_1/services/sensors/lux_service.dart';
import 'package:flutter_application_1/services/sensors/accelerometer_service.dart';
import 'package:flutter_application_1/services/mqtt_service.dart';
import '../blocs/start_stop_bloc.dart';
import '../services/sensors/location_service.dart';

/*
This is the start/stop button located on the home screen.
When the button is pressed, data is collected from the users device.
When it is pressed for the second time, the collection of data stops.
 */

class StartStopButton extends StatelessWidget {
  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final noiseService = Provider.of<NoiseService>(context, listen: false);
    final luxService = Provider.of<LuxService>(context, listen: false);
    final accelerometerService =
        Provider.of<AccelerometerService>(context, listen: false);
    final startStopBloc = Provider.of<StartStopBloc>(context);
    final mqttService = Provider.of<MqttService>(context, listen: false);
    final locationService = Provider.of<LocationService>(context);
    return StreamBuilder<bool>(
      stream: startStopBloc.startStopStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (snapshot.data == false) {
                    startStopBloc.switchState(true);
                    await mqttService.connect();
                    await mqttService.publishController();
                    luxService.start();
                    accelerometerService.start();
                    await noiseService.start();
                    locationService.start();
                    await locationService.determinePosition();

                } else if (snapshot.data == true) {
                  startStopBloc.switchState(false);
                  luxService.stop();
                  accelerometerService.stop();
                  noiseService.stop();
                  locationService.stop();
                  mqttService.disconnect();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: snapshot.data! ? Colors.red : Colors.green),
              child: Text(snapshot.data! ? 'Stop' : 'Start',
                  style: const TextStyle(fontSize: 20)),
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
