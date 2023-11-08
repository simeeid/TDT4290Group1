import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/services/login_service.dart';
import 'package:flutter_application_1/services/mqtt_service.dart';
import 'package:flutter_application_1/services/sensors/location_service.dart';
import 'package:flutter_application_1/services/sensors/noise_service.dart';
import 'package:flutter_application_1/services/sensors/lux_service.dart';
import 'package:flutter_application_1/services/sensors/accelerometer_service.dart';
import 'blocs/device_name_bloc.dart';
import 'blocs/sensors/location_bloc.dart';
import 'blocs/token_bloc.dart';
import 'blocs/username_bloc.dart';
import '../blocs/sensors/noise_bloc.dart';
import '../blocs/sensors/lux_bloc.dart';
import '../blocs/sensors/accelerometer_bloc.dart';
import 'blocs/start_stop_bloc.dart';
import 'package:provider/provider.dart';

/*
This is the file responsible for running the system.
All blocs and services are registered here, to make sure there only exists one
instance of them in the entire system.
The sign in screen is set as a starting view for the app.
 */

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
        Provider<LocationBloc>(
          create: (_) => LocationBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<TokenBloc>(
          create: (_) => TokenBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<UsernameBloc>(
          create: (_) => UsernameBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<DeviceNameBloc>(
          create: (_) => DeviceNameBloc(),
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
        Provider<MqttService>(
          create: (context) {
            return MqttService(
              usernameBloc: Provider.of<UsernameBloc>(context, listen: false),
              deviceNameBloc:
                  Provider.of<DeviceNameBloc>(context, listen: false),
              noiseBloc: Provider.of<NoiseBloc>(context, listen: false),
              luxBloc: Provider.of<LuxBloc>(context, listen: false),
              accelerometerBloc:
                  Provider.of<AccelerometerBloc>(context, listen: false),
              locationBloc: Provider.of<LocationBloc>(context, listen: false),
            );
          },
        ),
        Provider<LocationService>(
          create: (context) {
            return LocationService(
              locationBloc: Provider.of<LocationBloc>(context, listen: false),
            );
          },
        ),
        Provider<LogInService>(
          create: (context) {
            return LogInService(
              usernameBloc: Provider.of<UsernameBloc>(context, listen: false),
              tokenBloc: Provider.of<TokenBloc>(context, listen: false),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Norbit Mobile App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInScreen(),
      ),
    );
  }
}
