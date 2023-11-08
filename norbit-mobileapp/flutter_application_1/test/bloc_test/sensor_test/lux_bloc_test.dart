import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/sensors/lux_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:async/async.dart';

void main() {
  group('LuxBloc', () {
    late LuxBloc luxBloc;

    setUp(() {
      luxBloc = LuxBloc();
    });

    tearDown(() {
      luxBloc.dispose();
    });

    test('addLux updates the LuxStream', () async {
      final queue = StreamQueue(luxBloc.luxStream);
      luxBloc.addLux(10.0);
      expect(await queue.next, 10.0);
    });

    test('luxStream does not allow adding values after dispose is called', () {
      luxBloc.dispose();
      expect(() => luxBloc.addLux(10.0), throwsA(isA<StateError>()));
    });

    test('luxStream emits multiple values in the correct order', () async {
      final queue = StreamQueue(luxBloc.luxStream);
      luxBloc.addLux(10.0);
      luxBloc.addLux(20.0);
      expect(await queue.next, 10.0);
      expect(await queue.next, 20.0);
    });

    test('luxStream emits the last value added when listening', () async {
      luxBloc.addLux(10.0);
      expect(luxBloc.luxStream, emits(10.0));
    });
  });
}
