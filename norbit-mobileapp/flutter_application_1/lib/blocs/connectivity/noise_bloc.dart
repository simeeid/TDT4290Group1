import 'dart:async';
import 'package:rxdart/rxdart.dart';

class NoiseBloc {
  final noiseController = BehaviorSubject<double>();

  /* NoiseBloc() {
    _noiseController.add(10.0); // Add a static number to the stream
  } */

  Stream<double> get noiseStream => noiseController.stream;
  Sink<double> get noiseSink => noiseController.sink;

  void addNoise(double noise) {
    print("this is nooooise" + noise.toString());
    noiseSink.add(noise);
  }

  void dispose() {
    noiseController.close();
  }
}
