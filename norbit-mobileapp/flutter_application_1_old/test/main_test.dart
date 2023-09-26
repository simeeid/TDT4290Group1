import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // Replace with the actual import path

void main() {
  group('MyHomePage Widget Tests', () {
    testWidgets('Widget should build without any error',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Verify that the home page is rendered.
      expect(find.byType(MyHomePage), findsOneWidget);
    });

    testWidgets('Connect button should toggle connection',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Verify that the initial state of isConnected is false.
      expect(find.text('Connect'), findsOneWidget);
      expect(find.text('Disconnect'), findsNothing);

      // Tap the Connect button.
      await tester.tap(find.text('Connect'));
      await tester.pump();

      // Verify that the button toggles to Disconnect.
      expect(find.text('Connect'), findsNothing);
      expect(find.text('Disconnect'), findsOneWidget);
    });

    testWidgets('Start/Stop button should toggle data streaming',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // Verify that the initial state of isRunning is false.
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsNothing);

      // Tap the Start/Stop button.
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      // Verify that the button toggles to Stop.
      expect(find.byIcon(Icons.play_arrow), findsNothing);
      expect(find.byIcon(Icons.stop), findsOneWidget);
    });
  });
}
