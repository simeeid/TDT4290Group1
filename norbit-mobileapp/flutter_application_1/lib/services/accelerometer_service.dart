import 'dart:async';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  AccelerometerService({required AccelerometerBloc accelerometerBloc}) {

    final exampleEvent = AccelerometerEvent(0.5, -0.3, 0.7,);
    accelerometerBloc.addAccelerometer(exampleEvent);
  }
}