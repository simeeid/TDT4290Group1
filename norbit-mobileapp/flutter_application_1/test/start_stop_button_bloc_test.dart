import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/start_stop_button_bloc.dart';

void main() {
  late StartStopBloc startStopBloc;

  setUp(() {
    startStopBloc = StartStopBloc();
  });

  tearDown(() {
    startStopBloc.dispose();
  });

  test('Initial state of StartStopBloc is false', () {
    expect(startStopBloc.startStopStream, emitsInOrder([false]));
  });

  test('State of StartStopBloc should toggle after calling switchState', () {
    expectLater(
      startStopBloc.startStopStream,
      emitsInOrder([false, true]),
    );

    startStopBloc.switchState(true);
  });
}
