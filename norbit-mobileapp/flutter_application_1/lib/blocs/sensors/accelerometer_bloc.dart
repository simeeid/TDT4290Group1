import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

/*
  Flutter Bloc for accelerometer data management.
  Uses the `rxdart` package to create `AccelerometerBloc` class.
  Provides stream and sink for accelerometer data handling.
*/

class AccelerometerBloc {
  final _accelerometerController = BehaviorSubject<AccelerometerEvent>();

  Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerController.stream;

  Sink<AccelerometerEvent> get accelerometerSink =>
      _accelerometerController.sink;

  void addAccelerometer(AccelerometerEvent acc) {
    accelerometerSink.add(acc);
  }

  void dispose() {
    _accelerometerController.close();
  }
}
