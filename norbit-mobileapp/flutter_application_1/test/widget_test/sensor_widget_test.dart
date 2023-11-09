import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/sensor_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SensorWidget displays title and child widget', (WidgetTester tester) async {
    // Build the widget with a title and a child widget.
    await tester.pumpWidget(const MaterialApp(
      home: SensorWidget(
        title: 'Test Sensor',
        child: Text('Test Sensor Data'),
      ),
    ));

    // Verify that the title is displayed in the widget.
    expect(find.text('Test Sensor'), findsOneWidget);

    // Verify that the child widget is displayed in the widget.
    expect(find.text('Test Sensor Data'), findsOneWidget);
  });
}
