import 'package:flutter_application_1/blocs/sensors/lux_bloc.dart';
import 'package:flutter_application_1/services/sensors/lux_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LuxService Tests', () {
    test('Add lux data to bloc', () {
      final luxBloc = LuxBloc();
      final luxService = LuxService(luxBloc: luxBloc);

      const testLuxValue = 500; // Replace with a sample lux value for testing

      luxService.onData(testLuxValue);

      expect(luxBloc.luxStream, emits(testLuxValue.toDouble()));
    });
  });
}

