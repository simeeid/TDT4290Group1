// Import the required packages
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/sensors/lux_widget.dart';
import 'package:flutter_application_1/blocs/connectivity/lux_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  group('LuxWidget', () {
    late LuxBloc luxBloc;

    setUp(() {
      luxBloc = LuxBloc();
    });

    tearDown(() {
      luxBloc.dispose();
    });

    testWidgets('displays CircularProgressIndicator when no data is present',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LuxBloc>.value(
          value: luxBloc,
          child: MaterialApp(home: Scaffold(body: LuxWidget(luxBloc: luxBloc))),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays lux level when data is present',
        (WidgetTester tester) async {
      luxBloc.addLux(10.0);

      await tester.pumpWidget(
        Provider<LuxBloc>.value(
          value: luxBloc,
          child: MaterialApp(home: Scaffold(body: LuxWidget(luxBloc: luxBloc))),
        ),
      );

      await tester.pump();

      expect(find.text('Lux level: 10.00 Lx'), findsOneWidget);
    });
  });
}
