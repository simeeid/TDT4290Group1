import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:equatable/equatable.dart';

import 'connectivity_state.dart';

part 'connectivity_event.dart';
// part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  NoiseReading? _lastNoiseReading;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _lightSubscription;
  Light? _light;
  AccelerometerEvent? _lastAccelerometerEvent;
  int? _lastLuxValue;

  ConnectivityBloc() : super(Disconnected()) {
    _light = Light();
    _noiseMeter = NoiseMeter();

    on<Connect>((event, emit) async {
      emit(Connected());
    });

    on<Disconnect>((event, emit) async {
      emit(Disconnected());
      _accelerometerSubscription?.cancel();
      _lightSubscription?.cancel();
      _noiseSubscription?.cancel();
    });

    on<StartStop>((event, emit) async {
      if (state is DataStarted) {
        emit(DataStopped());
        _accelerometerSubscription?.cancel();
        _lightSubscription?.cancel();
        _noiseSubscription?.cancel();
      } else {
        emit(DataStarted());
        _accelerometerSubscription = accelerometerEvents.listen((event) {
          _lastAccelerometerEvent = event;
          add(UpdateData());
        });
        _lightSubscription = _light?.lightSensorStream.listen((luxValue) {
          _lastLuxValue = luxValue;
          add(UpdateData());
        });
        _noiseSubscription = _noiseMeter?.noise.listen((noiseReading) {
          _lastNoiseReading = noiseReading;
          add(UpdateData());
        });
      }
    });

    on<UpdateData>((event, emit) async {
      emit(DataUpdated(
          accelerometerEvent: _lastAccelerometerEvent,
          luxValue: _lastLuxValue,
          noiseReading: _lastNoiseReading));
    });
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
      _noiseSubscription?.cancel();
    } else if (event is StartStop) {
      if (state is DataStarted) {
        yield DataStopped();
        _accelerometerSubscription?.cancel();
        _lightSubscription?.cancel();
        _noiseSubscription?.cancel();
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
        _noiseSubscription = _noiseMeter?.noise.listen((noiseReading) {
          _lastNoiseReading = noiseReading;
          add(UpdateData());
        });
      }
    } else if (event is UpdateData) {
      yield DataUpdated(
          accelerometerEvent: _lastAccelerometerEvent,
          luxValue: _lastLuxValue,
          noiseReading: _lastNoiseReading);
    }
  }

  @override
  Future<void> close() {
    _accelerometerSubscription?.cancel();
    _lightSubscription?.cancel();
    return super.close();
  }
}
