import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/device_data.dart';
import 'package:flutter_application_1/blocs/device_name_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DeviceData widget displays device name', (WidgetTester tester) async {
    final deviceNameBloc = DeviceNameBloc();
    await tester.pumpWidget(MaterialApp(
      home: DeviceData(deviceNameBloc: deviceNameBloc),
    ));

    // Verify that the initial text in the widget is "N/A".
    expect(find.text("Device Name: N/A"), findsOneWidget);

    // Add a device name to the bloc and rebuild the widget.
    deviceNameBloc.addDeviceName("Test Device");
    await tester.pump();

    // Verify that the updated device name is displayed in the widget.
    expect(find.text("Device Name: Test Device"), findsOneWidget);
  });
}
