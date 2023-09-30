import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _lightSubscription;
  Light? _light;
  AccelerometerEvent? _lastAccelerometerEvent;
  int? _lastLuxValue;

  ConnectivityBloc() : super(Disconnected()) {
    _light = Light();
  }

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is Connect) {
      yield Connected();
    } else if (event is Disconnect) {
      yield Disconnected();
      _accelerometerSubscription?.cancel();
      _lightSubscription?.cancel();
    } else if (event is StartStop) {
      if (state is DataStarted) {
        yield DataStopped();
        _accelerometerSubscription?.cancel();
        _lightSubscription?.cancel();
      } else {
        yield DataStarted();
        _accelerometerSubscription = accelerometerEvents.listen((event) {
          _lastAccelerometerEvent = event;
          add(UpdateData());
        });
        _lightSubscription = _light?.lightSensorStream.listen((luxValue) {
          _lastLuxValue = luxValue;
          add(UpdateData());
        });
      }
    } else if (event is UpdateData) {
      yield DataUpdated(
          accelerometerEvent: _lastAccelerometerEvent, luxValue: _lastLuxValue);
    }
  }

  @override
  Future<void> close() {
    _accelerometerSubscription?.cancel();
    _lightSubscription?.cancel();
    return super.close();
  }
}
