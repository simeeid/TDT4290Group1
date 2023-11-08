import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/location_bloc.dart';
import 'package:flutter_application_1/services/sensors/noise_service.dart';
import 'package:flutter_application_1/services/sensors/lux_service.dart';
import 'package:flutter_application_1/services/sensors/accelerometer_service.dart';
import 'package:provider/provider.dart';
import '../blocs/sensors/noise_bloc.dart';
import '../blocs/sensors/lux_bloc.dart';
import '../blocs/sensors/accelerometer_bloc.dart';
import '../blocs/start_stop_bloc.dart';
import '../services/sensors/location_service.dart';
import '../widgets/sensors/accelerometer_widget.dart';
import '../widgets/sensors/location_widget.dart';
import '../widgets/sensors/lux_widget.dart';
import '../widgets/sensors/noise_widget.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/sensor_widget.dart';
import '../widgets/start_stop_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noiseBloc = Provider.of<NoiseBloc>(context);
    final luxBloc = Provider.of<LuxBloc>(context);
    final accelerometerBloc = Provider.of<AccelerometerBloc>(context);
    final locationBloc = Provider.of<LocationBloc>(context);
    final startStopBloc = Provider.of<StartStopBloc>(context);

    // DO NOT REMOVE
    // The code crashes if these are removed, even though they are unused
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    final noiseService = Provider.of<NoiseService>(context, listen: false);
    final luxService = Provider.of<LuxService>(context, listen: false);
    final accelerometerService =
        Provider.of<AccelerometerService>(context, listen: false);

    return StreamBuilder<bool>(
      stream: startStopBloc.startStopController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Norbit mobile app'),
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            drawer: const SidebarWidget(),
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
                            child: AccelerometerWidget(
                                accelerometerBloc: accelerometerBloc),
                          ),
                          const SizedBox(height: 16.0),
                          SensorWidget(
                            title: 'Light sensor',
                            child: LuxWidget(luxBloc: luxBloc),
                          ),
                          const SizedBox(height: 16.0),
                          SensorWidget(
                            title: 'Noisemeter',
                            child: NoiseWidget(noiseBloc: noiseBloc),
                          ),
                          const SizedBox(height: 16.0),
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
