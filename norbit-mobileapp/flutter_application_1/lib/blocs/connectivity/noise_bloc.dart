import 'dart:async';
import 'package:rxdart/rxdart.dart';

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
