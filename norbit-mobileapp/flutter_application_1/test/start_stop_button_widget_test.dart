import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:flutter_application_1/blocs/connectivity/location_bloc.dart';
import 'package:flutter_application_1/blocs/connectivity/lux_bloc.dart';
import 'package:flutter_application_1/blocs/connectivity/noise_bloc.dart';
import 'package:flutter_application_1/services/accelerometer_service.dart';
import 'package:flutter_application_1/services/location_service.dart';
import 'package:flutter_application_1/services/lux_service.dart';
import 'package:flutter_application_1/services/noise_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/widgets/start_stop_button_widget.dart';
import 'package:flutter_application_1/blocs/start_stop_bloc.dart';

void main() {
  late StartStopBloc startStopBloc;

  setUp(() {
    startStopBloc = StartStopBloc();
  });

  tearDown(() {
    startStopBloc.dispose();
  });

  testWidgets(
      'StartStopButton should display "Start" when startStopStream emits false',
      (WidgetTester tester) async {
    startStopBloc.switchState(false); // Ensure that StartStopBloc emits false

    final noiseService = NoiseService(noiseBloc: NoiseBloc());
    final luxService = LuxService(luxBloc: LuxBloc());
    final accelerometerService =
        AccelerometerService(accelerometerBloc: AccelerometerBloc());
    final LocationService locationService =
        LocationService(locationBloc: LocationBloc());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<StartStopBloc>.value(value: startStopBloc),
          Provider<NoiseService>.value(value: noiseService),
          Provider<LuxService>.value(value: luxService),
          Provider<AccelerometerService>.value(value: accelerometerService),
          Provider<LocationService>.value(value: locationService),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: StartStopButton(),
          ),
        ),
      ),
    );

    await tester.pump(); // Trigger a new frame

    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);
  });

  testWidgets(
      'StartStopButton should display "Stop" when startStopStream emits true',
      (WidgetTester tester) async {
    startStopBloc.switchState(true); // Ensure that StartStopBloc emits true

    final noiseService = NoiseService(noiseBloc: NoiseBloc());
    final luxService = LuxService(luxBloc: LuxBloc());
    final accelerometerService =
        AccelerometerService(accelerometerBloc: AccelerometerBloc());
    final LocationService locationService =
        LocationService(locationBloc: LocationBloc());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<StartStopBloc>.value(value: startStopBloc),
          Provider<NoiseService>.value(value: noiseService),
          Provider<LuxService>.value(value: luxService),
          Provider<AccelerometerService>.value(value: accelerometerService),
          Provider<LocationService>.value(value: locationService),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: StartStopButton(),
          ),
        ),
      ),
    );

    await tester.pump(); // Trigger a new frame

    expect(find.text('Start'), findsNothing);
    expect(find.text('Stop'), findsOneWidget);
  });
}
