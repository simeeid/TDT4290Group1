import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for lux data management.
  Uses the `rxdart` package to create `LuxBloc` class.
  Provides stream and sink for lux data handling.
*/

class LuxBloc {
  final _luxController = BehaviorSubject<double>();

  Stream<double> get luxStream => _luxController.stream;

  Sink<double> get luxSink => _luxController.sink;

  void addLux(double lux) {
    luxSink.add(lux);
  }

  void dispose() {
    _luxController.close();
  }
}
