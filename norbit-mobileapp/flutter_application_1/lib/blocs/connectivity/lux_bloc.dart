import 'dart:async';
import 'package:rxdart/rxdart.dart';

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