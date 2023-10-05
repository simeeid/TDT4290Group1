import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerBloc {
  // Create controller
  final _accelerometerController = BehaviorSubject<AccelerometerEvent>();

  // Provide a stream getter
  Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerController.stream;

  // Provide a sink getter
  Sink<AccelerometerEvent> get accelerometerSink =>
      _accelerometerController.sink;

  // You can add methods for your business logic here
  // For example, to add a new accelerometer event to the stream:
  void addAccelerometerEvent(AccelerometerEvent event) {
    accelerometerSink.add(event);
  }

  // Always close your stream controllers!
  void dispose() {
    _accelerometerController.close();
  }
}
