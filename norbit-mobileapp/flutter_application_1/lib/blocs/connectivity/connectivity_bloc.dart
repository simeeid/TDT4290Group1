import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:noise_meter/noise_meter.dart';

import 'connectivity_state.dart';
import '../../mocks.dart';
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

/* The constructor in this file is designed to accept instances of Light, 
NoiseMeter, and SensorWrapper as parameters. This is done to make 
the ConnectivityBloc class more flexible and testable. 
By passing these instances to the constructor, you can control the dependencies of 
the ConnectivityBloc class. In a real app, you would pass real instances 
to interact with the device’s sensors. In tests, you can pass mock instances 
to simulate sensor data */

  final Light light;
  final NoiseMeter noiseMeter;
  final SensorWrapper sensorWrapper;

  ConnectivityBloc(
      {required this.light,
      required this.noiseMeter,
      required this.sensorWrapper})
      : super(Disconnected()) {
    _light = light;
    _noiseMeter = noiseMeter;

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
