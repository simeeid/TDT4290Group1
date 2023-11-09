import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/blocs/sensors/location_bloc.dart';

void main() {
  late LocationBloc locationBloc;

  setUp(() {
    locationBloc = LocationBloc();
  });

  tearDown(() {
    locationBloc.dispose();
  });

  test('LocationBloc should emit a Position when addLocation is called', () {
    final testPosition = Position(
      latitude: 37.4219983,
      longitude: -122.084,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    locationBloc.addLocation(testPosition);

    expect(
      locationBloc.locationController,
      emits(testPosition), // Expect to receive the test position
    );
  });

  test('Initial state of LocationBloc is correct', () {
    expect(locationBloc.locationController.valueOrNull, isNull);
  });

  test('LocationBloc emits multiple Positions in correct order', () async {
    final testPosition1 = Position(
      latitude: 37.4219983,
      longitude: -122.084,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    final testPosition2 = Position(
      latitude: 37.422,
      longitude: -122.085,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    final emittedPositions = [];

    // Listen to the stream and add emitted positions to the list
    final subscription = locationBloc.locationController.listen((position) {
      emittedPositions.add(position);
    });

    locationBloc.addLocation(testPosition1);
    locationBloc.addLocation(testPosition2);

    // Wait for a short delay to ensure that all positions are added
    await Future.delayed(const Duration(milliseconds: 100));

    // Close the stream
    await subscription.cancel();

    expect(emittedPositions, equals([testPosition1, testPosition2]));
  });
}
