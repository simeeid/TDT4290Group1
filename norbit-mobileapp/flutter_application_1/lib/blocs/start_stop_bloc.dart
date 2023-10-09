import 'package:rxdart/rxdart.dart';

class StartStopBloc {
  final startStopController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get startStopStream => startStopController.stream;
  Sink<bool> get startStopSink => startStopController.sink;

  void switchState(bool b) {
    startStopSink.add(b);
  }

  void dispose() {
    startStopController.close();
  }
}