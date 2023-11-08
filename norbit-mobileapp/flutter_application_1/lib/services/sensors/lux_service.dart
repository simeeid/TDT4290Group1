import 'dart:async';
import 'package:flutter_application_1/blocs/sensors/lux_bloc.dart';
import 'package:light/light.dart';

class LuxService {
  StreamSubscription<int>? _subscription;
  Light? _light;
  final LuxBloc luxBloc;

  LuxService({required this.luxBloc});

  void onData(int luxValue) async {
    luxBloc.addLux(luxValue.toDouble());
  }

  void stop() {
    _subscription?.cancel();
  }

  Future<void> start() async {
    _light = Light();
    try {
      _subscription = _light?.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }
}