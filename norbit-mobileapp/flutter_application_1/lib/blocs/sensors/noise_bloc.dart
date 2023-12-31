import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for noise data management.
  Uses the `rxdart` package to create `NoiseBloc` class.
  Provides stream and sink for noise data handling.
*/

class NoiseBloc {
  final _noiseController = BehaviorSubject<double>();

  Stream<double> get noiseStream => _noiseController.stream;

  Sink<double> get noiseSink => _noiseController.sink;

  void addNoise(double noise) {
    noiseSink.add(noise);
  }

  void dispose() {
    _noiseController.close();
  }
}
