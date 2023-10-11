import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/sensors/noise_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/blocs/connectivity/noise_bloc.dart';

void main() {
  group('NoiseWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      final noiseBloc = NoiseBloc();
      noiseBloc.addNoise(0.0); // Add a noise value to the bloc

      await tester.pumpWidget(
        Provider<NoiseBloc>.value(
          value: noiseBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NoiseWidget(noiseBloc: noiseBloc),
            ),
          ),
        ),
      );

      // Allow the widget tree to rebuild after state change
      await tester.pump();

      expect(find.text('Noise level: 0.00 dB'), findsOneWidget);
    });

    testWidgets('displays different noise levels correctly',
        (WidgetTester tester) async {
      final noiseBloc = NoiseBloc();

      await tester.pumpWidget(
        Provider<NoiseBloc>.value(
          value: noiseBloc,
          child: MaterialApp(
            home: Scaffold(
              body: NoiseWidget(noiseBloc: noiseBloc),
            ),
          ),
        ),
      );

      noiseBloc.addNoise(10.0);
      await tester.pump();
      expect(find.text('Noise level: 10.00 dB'), findsOneWidget);

      noiseBloc.addNoise(20.0);
      await tester.pump();
      expect(find.text('Noise level: 20.00 dB'), findsOneWidget);
    });
  });
}
