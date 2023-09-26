part of 'connectivity_bloc.dart';

abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class Connected extends ConnectivityState {}

class Disconnected extends ConnectivityState {}

class DataStarted extends Connected {}

class DataStopped extends Connected {}

class DataUpdated extends DataStarted {
  final AccelerometerEvent accelerometerEvent;

  DataUpdated(this.accelerometerEvent);
}
