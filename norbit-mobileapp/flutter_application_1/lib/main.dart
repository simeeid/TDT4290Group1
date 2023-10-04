import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:light/light.dart';
import 'blocs/connectivity/connectivity_bloc.dart';
import 'screens/home_screen.dart';
import 'mocks.dart';

void main() {
  runApp(const MyApp());
}

/* In this file, we’re creating a ConnectivityBloc and providing it to 
our app using BlocProvider. We’re passing real instances of Light, 
NoiseMeter, and SensorWrapper to the constructor of ConnectivityBloc. 
This is because in the actual app, you want to use 
the real sensor APIs to get real sensor data. */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
