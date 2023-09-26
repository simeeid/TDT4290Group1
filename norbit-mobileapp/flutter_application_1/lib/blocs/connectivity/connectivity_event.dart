part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class Connect extends ConnectivityEvent {}

class Disconnect extends ConnectivityEvent {}

class StartStop extends ConnectivityEvent {}

class UpdateData extends ConnectivityEvent {
  final AccelerometerEvent accelerometerEvent;

  UpdateData(this.accelerometerEvent);
}
