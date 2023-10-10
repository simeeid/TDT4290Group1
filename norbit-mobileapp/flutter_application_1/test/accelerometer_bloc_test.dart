import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  late AccelerometerBloc accelerometerBloc;

  setUp(() {
    accelerometerBloc = AccelerometerBloc();
  });

  tearDown(() {
    accelerometerBloc.dispose();
  });

  test('AccelerometerBloc emits [] when nothing is added', () {
    expectLater(
      accelerometerBloc.accelerometerStream,
      emitsInOrder([]),
    );
  });

  test(
      'AccelerometerBloc emits [AccelerometerEvent] when addAccelerometer is called',
      () {
    final event = AccelerometerEvent(1.0, 2.0, 3.0);
    accelerometerBloc.addAccelerometer(event);
    expect(accelerometerBloc.accelerometerStream, emits(event));
  });
}
