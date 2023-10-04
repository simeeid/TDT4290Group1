import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_application_1/mocks.dart';
import 'package:flutter_application_1/blocs/connectivity/connectivity_bloc.dart';
import 'package:flutter_application_1/blocs/connectivity/connectivity_state.dart';

/* In this file, we’re creating a ConnectivityBloc for testing purposes. 
However, instead of passing real instances to its constructor, 
we’re passing mock instances that we defined in our test setup. 
These mock instances simulate the behavior of the real sensor APIs, 
allowing us to test the logic of BLoC in isolation from external dependencies. */

class MockLight extends Mock implements Light {
  @override
  Stream<int> get lightSensorStream => Stream.value(100);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ConnectivityBloc', () {
    late ConnectivityBloc connectivityBloc;
    late MockLight light;
    late NoiseMeter noiseMeter;
    late SensorWrapper sensorWrapper;

    setUp(() {
      light = MockLight();
      noiseMeter = MockNoiseMeter();
      sensorWrapper = MockSensorWrapper();
      connectivityBloc = ConnectivityBloc(
          light: light, noiseMeter: noiseMeter, sensorWrapper: sensorWrapper);
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

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [DataStarted] when StartStop event is added and current state is Connected',
      build: () => connectivityBloc,
      act: (bloc) => bloc
        ..add(Connect())
        ..add(StartStop()),
      expect: () => [
        Connected(),
        DataStarted(),
        isA<DataUpdated>(),
        isA<DataUpdated>(),
      ],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [DataStopped] when StartStop event is added and current state is DataStarted',
      build: () => connectivityBloc,
      act: (bloc) => bloc
        ..add(Connect())
        ..add(StartStop())
        ..add(StartStop()),
      expect: () => [
        Connected(),
        DataStarted(),
        DataStopped(),
        isA<DataUpdated>(),
        isA<DataUpdated>(),
      ],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [DataUpdated] when UpdateData event is added and current state is DataStarted',
      build: () => connectivityBloc,
      act: (bloc) => bloc
        ..add(Connect())
        ..add(StartStop())
        ..add(UpdateData()),
      expect: () => [
        Connected(),
        DataStarted(),
        isA<DataUpdated>(),
        isA<DataUpdated>(),
        isA<DataUpdated>(),
      ],
    );
  });
}
