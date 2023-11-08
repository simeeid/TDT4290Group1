import 'dart:async';
import 'package:rxdart/rxdart.dart';

class NoiseBloc {
  final noiseController = BehaviorSubject<double>();

  Stream<double> get noiseStream => noiseController.stream;

  Sink<double> get noiseSink => noiseController.sink;

  void addNoise(double noise) {
    noiseSink.add(noise);
  }

  void dispose() {
    noiseController.close();
  }
}
