import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:light/light.dart';
import 'blocs/connectivity/connectivity_bloc.dart';
import 'screens/home_screen.dart';
import 'mocks.dart';
import '../blocs/connectivity/noise_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/accelerometer_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NoiseBloc>(
          create: (_) {
            print("NoiseBloc created");
            return NoiseBloc();
          },
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<LuxBloc>(
          create: (_) => LuxBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<AccelerometerBloc>(
          create: (_) => AccelerometerBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<NoiseService>(
          create: (context) {
            print("NoiseService created");
            return NoiseService(
              noiseBloc: Provider.of<NoiseBloc>(context, listen: false),
            );
          },
        ),
        Provider<LuxService>(
          create: (context) {
            return LuxService(
              luxBloc: Provider.of<LuxBloc>(context, listen: false),
            );
          },
        ),
        Provider<AccelerometerService>(
          create: (context) {
            return AccelerometerService(
              accelerometerBloc: Provider.of<AccelerometerBloc>(context, listen: false),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Accelerometer App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => ConnectivityBloc(
              light: Light(),
              noiseMeter: NoiseMeter(),
              sensorWrapper: SensorWrapper()),
          child: HomeScreen(),
        ),
      ),
    );
  }
}