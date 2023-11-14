import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for management of the state of the start/stop button.
  Uses the `rxdart` package to create `StartStopBloc` class.
  Provides stream and sink for handling of the start/stop button state
*/

class StartStopBloc {
  final _startStopController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get startStopStream => _startStopController.stream;

  Sink<bool> get startStopSink => _startStopController.sink;

  void switchState(bool b) {
    startStopSink.add(b);
  }

  void dispose() {
    _startStopController.close();
  }
}
