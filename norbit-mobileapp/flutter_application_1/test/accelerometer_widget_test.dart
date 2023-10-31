import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:flutter_application_1/widgets/sensors/accelerometer_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

void main() {
  late AccelerometerBloc accelerometerBloc;

  setUp(() {
    accelerometerBloc = AccelerometerBloc();
  });

  tearDown(() {
    accelerometerBloc.dispose();
  });

  testWidgets(
      'AccelerometerWidget displays correct data when AccelerometerBloc emits a state',
      (WidgetTester tester) async {
    final event = AccelerometerEvent(1.0, 2.0, 3.0);
    accelerometerBloc.addAccelerometer(event);

    await tester.pumpWidget(
      Provider<AccelerometerBloc>.value(
        value: accelerometerBloc,
        child: MaterialApp(
            home: Scaffold(
                body:
                    AccelerometerWidget(accelerometerBloc: accelerometerBloc))),
      ),
    );

    await tester.pump(); // Trigger a new frame

    expect(find.text('X: ${event.x.toStringAsFixed(2)}'), findsOneWidget);
    expect(find.text('Y: ${event.y.toStringAsFixed(2)}'), findsOneWidget);
    expect(find.text('Z: ${event.z.toStringAsFixed(2)}'), findsOneWidget);
  });
}
