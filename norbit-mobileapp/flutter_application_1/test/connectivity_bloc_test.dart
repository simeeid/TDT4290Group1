import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';
import '../lib/blocs/connectivity/connectivity_bloc.dart';
import '../lib/blocs/connectivity/connectivity_state.dart';

class MockLight extends Mock implements Light {}

class MockNoiseMeter extends Mock implements NoiseMeter {}

void main() {
  group('ConnectivityBloc', () {
    late ConnectivityBloc connectivityBloc;

    setUp(() {
      connectivityBloc = ConnectivityBloc();
    });

    tearDown(() {
      connectivityBloc.close();
    });

    test('initial state is Disconnected', () {
      expect(connectivityBloc.state, Disconnected());
    });

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [Connected] when Connect event is added',
      build: () => connectivityBloc,
      act: (bloc) => bloc.add(Connect()),
      expect: () => [Connected()],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [Disconnected] when Disconnect event is added',
      build: () => connectivityBloc,
      act: (bloc) => bloc.add(Disconnect()),
      expect: () => [Disconnected()],
    );

    // Add more tests for StartStop and UpdateData events here.
  });
}
