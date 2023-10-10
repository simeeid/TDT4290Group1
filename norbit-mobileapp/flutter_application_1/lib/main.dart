import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';
import 'screens/home_screen.dart';
import 'mocks.dart';
import '../blocs/connectivity/noise_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/accelerometer_bloc.dart';
import 'blocs/start_stop_button_bloc.dart';
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
        Provider<StartStopBloc>(
          create: (_) => StartStopBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<NoiseService>(
          create: (context) {
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
              accelerometerBloc:
                  Provider.of<AccelerometerBloc>(context, listen: false),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Accelerometer App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
