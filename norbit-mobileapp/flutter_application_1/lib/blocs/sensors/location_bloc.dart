import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc {
  final locationController = BehaviorSubject<Position>();

  Stream<Position> get accelerometerStream => locationController.stream;
  Sink<Position> get accelerometerSink => locationController.sink;

  void addLocation(Position loc) {
    accelerometerSink.add(loc);
  }

  void dispose() {
    locationController.close();
  }
}