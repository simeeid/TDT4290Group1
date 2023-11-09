import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/accelerometer_bloc.dart';
import 'package:flutter_application_1/blocs/device_name_bloc.dart';
import 'package:flutter_application_1/blocs/sensors/location_bloc.dart';
import 'package:flutter_application_1/blocs/sensors/lux_bloc.dart';
import 'package:flutter_application_1/blocs/sensors/noise_bloc.dart';
import 'package:flutter_application_1/blocs/username_bloc.dart';
import 'package:flutter_application_1/services/sensors/accelerometer_service.dart';
import 'package:flutter_application_1/services/sensors/location_service.dart';
import 'package:flutter_application_1/services/sensors/lux_service.dart';
import 'package:flutter_application_1/services/sensors/noise_service.dart';
import 'package:flutter_application_1/services/mqtt_service.dart';
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

/*
 * When adding a new sensor to the application, there are a few steps that need 
 * to be taken in order for the tests to function correctly:
 *
 * 1. Import the new sensor's service and bloc in the test file.
 *    Example: 
 *    import 'package:flutter_application_1/blocs/connectivity/new_sensor_bloc.dart';
 *    import 'package:flutter_application_1/services/new_sensor_service.dart';
 *
 * 2. Create instances of the new sensor's service and bloc in each test case.
 *    Example: 
 *    final newSensorService = NewSensorService(newSensorBloc: NewSensorBloc());
 *
 * 3. Add the new sensor's service to the list of providers in the MultiProvider widget.
 *    Example: 
 *    Provider<NewSensorService>.value(value: newSensorService),
 *
 * The reason for this structure is that each widget in the application that depends 
 * on a sensor needs to have access to that sensor's data. This is achieved through 
 * Flutter's provider package, which allows widgets to listen for changes in the sensor 
 * data and rebuild when new data is available. In order for the tests to simulate 
 * this behavior, they need to provide mock instances of each sensor's service.
 */

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
    final mqttService = MqttService(
        noiseBloc: NoiseBloc(),
        luxBloc: LuxBloc(),
        accelerometerBloc: AccelerometerBloc(),
        locationBloc: LocationBloc(),
        usernameBloc: UsernameBloc(),
        deviceNameBloc: DeviceNameBloc());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          // Add the new sensor's service to the list of providers
          Provider<StartStopBloc>.value(value: startStopBloc),
          Provider<NoiseService>.value(value: noiseService),
          Provider<LuxService>.value(value: luxService),
          Provider<AccelerometerService>.value(value: accelerometerService),
          Provider<LocationService>.value(value: locationService),
          Provider<MqttService>.value(value: mqttService),
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

    // Create instances of the new sensor's service and bloc in each test case
    final noiseService = NoiseService(noiseBloc: NoiseBloc());
    final luxService = LuxService(luxBloc: LuxBloc());
    final accelerometerService =
        AccelerometerService(accelerometerBloc: AccelerometerBloc());
    final LocationService locationService =
        LocationService(locationBloc: LocationBloc());
    final mqttService = MqttService(
        noiseBloc: NoiseBloc(),
        luxBloc: LuxBloc(),
        accelerometerBloc: AccelerometerBloc(),
        locationBloc: LocationBloc(),
        usernameBloc: UsernameBloc(),
        deviceNameBloc: DeviceNameBloc());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          // Add the new sensor's service to the list of providers
          Provider<StartStopBloc>.value(value: startStopBloc),
          Provider<NoiseService>.value(value: noiseService),
          Provider<LuxService>.value(value: luxService),
          Provider<AccelerometerService>.value(value: accelerometerService),
          Provider<LocationService>.value(value: locationService),
          Provider<MqttService>.value(value: mqttService),
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
