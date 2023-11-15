import 'package:flutter_application_1/blocs/sensors/noise_bloc.dart';
import 'package:flutter_application_1/services/sensors/noise_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:noise_meter/noise_meter.dart';

class MockNoiseBloc extends Mock implements NoiseBloc {}

void main() {
  group('NoiseService Tests', () {
    test('Add noise data to bloc', () {
      final mockNoiseBloc = MockNoiseBloc();
      final noiseService = NoiseService(noiseBloc: mockNoiseBloc);

      final testNoiseReading = NoiseReading([75.0]); // Replace with a sample noise reading for testing

      noiseService.onData(testNoiseReading);

      verify(mockNoiseBloc.addNoise(testNoiseReading.meanDecibel.toDouble()));
    });
  });
}
