import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription? _accelerometerSubscription;

  // ConnectivityBloc() : super(ConnectivityInitial());
  ConnectivityBloc() : super(Disconnected());

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is Connect) {
      yield Connected();
    } else if (event is Disconnect) {
      yield Disconnected();
      _accelerometerSubscription?.cancel();
    } else if (event is StartStop) {
      if (state is DataStarted) {
        yield DataStopped();
        _accelerometerSubscription?.cancel();
      } else {
        yield DataStarted();
        _accelerometerSubscription = accelerometerEvents.listen((event) {
          add(UpdateData(event));
        });
      }
    } else if (event is UpdateData) {
      yield DataUpdated(event.accelerometerEvent);
    }
  }

  @override
  Future<void> close() {
    _accelerometerSubscription?.cancel();
    return super.close();
  }
}
