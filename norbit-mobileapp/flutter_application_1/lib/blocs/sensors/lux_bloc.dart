import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for lux data management.
  Uses the `rxdart` package to create `LuxBloc` class.
  Provides stream and sink for lux data handling.
*/

class LuxBloc {
  final luxController = BehaviorSubject<double>();

  Stream<double> get luxStream => luxController.stream;

  Sink<double> get luxSink => luxController.sink;

  void addLux(double lux) {
    luxSink.add(lux);
  }

  void dispose() {
    luxController.close();
  }
}
