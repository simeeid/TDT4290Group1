import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/connectivity/location_bloc.dart';
import 'package:flutter_application_1/widgets/sensors/location_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  group('LocationWidget', () {
    late LocationBloc locationBloc;

    setUp(() {
      locationBloc = LocationBloc();
    });

    testWidgets('displays CircularProgressIndicator when no data',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LocationWidget(locationBloc: locationBloc),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays location data when snapshot has data',
        (WidgetTester tester) async {
      final position = Position(
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

      locationBloc.addLocation(position);

      await tester.pumpWidget(MaterialApp(
        home: LocationWidget(locationBloc: locationBloc),
      ));

      // Wait for the next frame.
      await tester.pump();

      expect(find.text('Latitude: ${position.latitude}'), findsOneWidget);
      expect(find.text('Longitude: ${position.longitude}'), findsOneWidget);
    });

    testWidgets(
        'does not display CircularProgressIndicator when snapshot has data',
        (WidgetTester tester) async {
      final position = Position(
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

      locationBloc.addLocation(position);

      await tester.pumpWidget(MaterialApp(
        home: LocationWidget(locationBloc: locationBloc),
      ));

      // Wait for the next frame.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
