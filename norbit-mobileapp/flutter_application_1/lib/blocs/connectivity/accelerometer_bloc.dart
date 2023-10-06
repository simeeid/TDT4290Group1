import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerBloc {
  final accelerometerController = BehaviorSubject<AccelerometerEvent>();

  Stream<AccelerometerEvent> get accelerometerStream =>
      accelerometerController.stream;

  Sink<AccelerometerEvent> get accelerometerSink =>
      accelerometerController.sink;

  void addAccelerometerEvent(AccelerometerEvent event) {
    accelerometerSink.add(event);
  }

  void dispose() {
    accelerometerController.close();
  }
}
