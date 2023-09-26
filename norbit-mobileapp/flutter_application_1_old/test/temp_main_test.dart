import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Test the app UI without actual connection and sensor data',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the initial state is as expected.
    expect(find.text('MQTT App'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
    expect(find.text('Disconnect'), findsNothing);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);
    expect(find.text('Accelerometer Data:\nX: 0.00\nY: 0.00\nZ: 0.00'),
        findsOneWidget);

    // Tap the Connect button.
    await tester.tap(find.text('Connect'));
    await tester.pump();

    // Verify that the state has changed after tapping Connect.
    expect(find.text('Connect'), findsNothing);
    expect(find.text('Disconnect'), findsOneWidget);

    // Tap the Play button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the state has changed after tapping Play.
    expect(find.text('Play'), findsNothing);
    expect(find.text('Stop'), findsOneWidget);

    // Tap the Stop button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the state has changed after tapping Stop.
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);
  });
}
