part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class Connect extends ConnectivityEvent {}

class Disconnect extends ConnectivityEvent {}

class StartStop extends ConnectivityEvent {}

class UpdateAccelData extends ConnectivityEvent {
  final AccelerometerEvent accelerometerEvent;

  UpdateAccelData(this.accelerometerEvent);
}

class UpdateLightData extends ConnectivityEvent {
  final int luxValue;

  UpdateLightData(this.luxValue);
}

class UpdateData extends ConnectivityEvent {} // Add this line
