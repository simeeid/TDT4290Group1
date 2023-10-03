// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';

// Description of mock and its usage is at the bottom of this file

class MockLight extends Mock implements Light {
  @override
  Stream<int> get lightSensorStream => Stream.value(100);
}

class MockNoiseReading extends Mock implements NoiseReading {
  @override
  double get meanDecibel => 100.0;
  @override
  double get maxDecibel => 100.0;
}

class MockNoiseMeter extends Mock implements NoiseMeter {
  @override
  Stream<NoiseReading> get noise => Stream.value(MockNoiseReading());
}

class SensorWrapper {
  // ignore: recursive_getters
  Stream<AccelerometerEvent> get accelerometerEvents => accelerometerEvents;
}

class MockSensorWrapper extends Mock implements SensorWrapper {
  @override
  Stream<AccelerometerEvent> get accelerometerEvents =>
      Stream.value(AccelerometerEvent(1.0, 2.0, 3.0));
}

/* The `mocks.dart` file is created to define mock classes for testing purposes. 
Mocking is a technique used in unit testing to simulate the behavior of real objects. 
In the context of this Flutter app, the real objects are the sensor APIs 
(`Light`, `NoiseMeter`, and `AccelerometerEvent`) that interact with the device's hardware.

The reason we use mocks is that we want our unit tests to be fast, reliable, 
and isolated from external factors. Accessing the real sensor APIs would make our tests slow 
(because accessing hardware is usually slow), 
unreliable (because the sensor data can vary depending on the environment), 
and not isolated (because they depend on the device's hardware).

Here's how the mock classes in `mocks.dart` are used:

1. MockLight: This class mocks the `Light` class from the `light` package. 
It overrides the `lightSensorStream` getter to return a stream of fixed light sensor values. 
This way, when our tests listen to this stream, they will receive predictable data.

2. MockNoiseMeter and MockNoiseReading: These classes mock the `NoiseMeter` class 
and `NoiseReading` class from the `noise_meter` package. They override 
the `noise` getter in `MockNoiseMeter` to return a stream of `MockNoiseReading` instances, 
which have fixed noise level values.

3. SensorWrapper and MockSensorWrapper: These classes are used to wrap 
the `accelerometerEvents` stream from the `sensors_plus` package. 
The reason we need a wrapper is that `accelerometerEvents` is a top-level variable, 
not a class, so we can't directly mock it. The `MockSensorWrapper` overrides 
the `accelerometerEvents` getter to return a stream of fixed accelerometer events.

In our tests, we create instances of these mock classes and pass them to BLoC. 
This way, BLoC will use these mock instances instead of the real sensor APIs, 
allowing to test its logic in isolation.*/