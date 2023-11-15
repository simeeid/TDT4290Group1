import 'package:flutter_application_1/services/sensors/accelerometer_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/sensors/accelerometer_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  group('AccelerometerService Tests', () {

    test('Add accelerometer data to bloc', () {
      final accelerometerBloc = AccelerometerBloc();
      final accelerometerService = AccelerometerService(accelerometerBloc: accelerometerBloc);

      final testEvent = AccelerometerEvent(1.0, 2.0, 3.0);

      accelerometerService.onData(testEvent);

      expectLater(
        accelerometerBloc.accelerometerStream,
        emits(testEvent),
      );
    });
  });
}
