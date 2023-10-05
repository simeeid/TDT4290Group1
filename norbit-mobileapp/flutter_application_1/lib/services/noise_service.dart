import 'dart:async';
import 'package:flutter_application_1/blocs/connectivity/noise_bloc.dart';
import 'package:noise_meter/noise_meter.dart';

class NoiseService {
  NoiseService({required NoiseBloc noiseBloc}) {
    noiseBloc.addNoise(7);
  }
  void TestService() {
    print("service is connected");
  }
}
