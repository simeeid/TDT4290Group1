import 'package:equatable/equatable.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:noise_meter/noise_meter.dart';

abstract class ConnectivityState extends Equatable {
  @override
  List<Object> get props => [];
}

class Connected extends ConnectivityState {}

class Disconnected extends ConnectivityState {}

class DataStarted extends Connected {}

class DataStopped extends Connected {}

class DataUpdated extends DataStarted {
  final AccelerometerEvent? accelerometerEvent;
  final int? luxValue;
  final NoiseReading? noiseReading;

  DataUpdated({this.accelerometerEvent, this.luxValue, this.noiseReading});

  @override
  List<Object> get props => [accelerometerEvent, luxValue, noiseReading]
      .map((e) => e ?? Object())
      .toList();
}
