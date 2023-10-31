import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';

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

  test('accelerometerStream emits multiple values in the correct order',
      () async {
    final queue = StreamQueue(accelerometerBloc.accelerometerStream);
    final event1 = AccelerometerEvent(1.0, 2.0, 3.0);
    final event2 = AccelerometerEvent(4.0, 5.0, 6.0);
    accelerometerBloc.addAccelerometer(event1);
    expect(await queue.next, event1);
    accelerometerBloc.addAccelerometer(event2);
    expect(await queue.next, event2);
  });
}
