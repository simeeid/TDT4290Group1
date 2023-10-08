import 'dart:async';
import 'package:flutter_application_1/blocs/connectivity/noise_bloc.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class NoiseService {
  NoiseReading? latestReading;
  StreamSubscription<NoiseReading>? noiseSubscription;
  NoiseMeter? noiseMeter;
  bool isRecording = false;
  final NoiseBloc noiseBloc;

  NoiseService({required this.noiseBloc});

  void stop() {
    noiseSubscription?.cancel();
    isRecording = false;
  }

  void onData(NoiseReading noiseReading) {
    latestReading = noiseReading;
    print("THIIIIS ISSSS $noiseReading !!!!!!!!!!!!!!!!!!!!!");
    noiseBloc.addNoise(noiseReading.meanDecibel.toDouble());
  }

  void onError(Object error) {
    print(error);
    stop();
  }

  Future<bool> checkPermission() async =>
      await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  Future<void> start() async {
    noiseMeter ??= NoiseMeter();
    if (!(await checkPermission())) await requestPermission();
    noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    isRecording = true;
  }
}
