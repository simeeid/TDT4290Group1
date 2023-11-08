import 'dart:async';
import 'package:flutter_application_1/blocs/sensors/accelerometer_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  final AccelerometerBloc accelerometerBloc;

  AccelerometerService({required this.accelerometerBloc});

  void onData(AccelerometerEvent event) {
    accelerometerBloc.addAccelerometer(event);
  }

  void stop() {
    _subscription?.cancel();
  }

  Future<void> start() async {
    try {
      _subscription = accelerometerEvents.listen(onData);
    } on Exception catch (e) {
      print(e);
    }
  }
}
