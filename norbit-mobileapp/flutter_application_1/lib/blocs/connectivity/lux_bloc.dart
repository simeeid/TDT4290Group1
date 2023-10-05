import 'dart:async';
import 'package:rxdart/rxdart.dart';

class LuxBloc {
  // Create controller
  final _luxController = BehaviorSubject<double>();

  // Provide a stream getter
  Stream<double> get luxStream => _luxController.stream;

  // Provide a sink getter
  Sink<double> get luxSink => _luxController.sink;

  // You can add methods for your business logic here
  // For example, to add a new lux value to the stream:
  void addLux(double lux) {
    luxSink.add(lux);
  }

  // Always close your stream controllers!
  void dispose() {
    _luxController.close();
  }
}
