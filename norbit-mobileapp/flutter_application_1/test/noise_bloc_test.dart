import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/connectivity/noise_bloc.dart';

void main() {
  group('NoiseBloc', () {
    late NoiseBloc noiseBloc;

    setUp(() {
      noiseBloc = NoiseBloc();
    });

    tearDown(() {
      noiseBloc.dispose();
    });

    test('addNoise changes state', () {
      final List<double> expectedResponse = [10.0];
      expectLater(
        noiseBloc.noiseStream,
        emitsInOrder(expectedResponse),
      );
      noiseBloc.addNoise(10.0);
    });

    test('dispose will close the NoiseBloc', () {
      expect(noiseBloc.noiseController.isClosed, isFalse);
      noiseBloc.dispose();
      expect(noiseBloc.noiseController.isClosed, isTrue);
    });

    test('addNoise emits correct sequence of states', () {
      final List<double> expectedResponse = [10.0, 20.0, 30.0];
      expectLater(
        noiseBloc.noiseStream,
        emitsInOrder(expectedResponse),
      );
      noiseBloc.addNoise(10.0);
      noiseBloc.addNoise(20.0);
      noiseBloc.addNoise(30.0);
    });
  });
}
