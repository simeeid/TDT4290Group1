import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for location data management.
  Uses the `rxdart` package to create `LocationBloc` class.
  Provides stream and sink for location data handling.
*/

class LocationBloc {
  final _locationController = BehaviorSubject<Position>();

  Stream<Position> get locationStream => _locationController.stream;

  Sink<Position> get locationSink => _locationController.sink;

  void addLocation(Position loc) {
    locationSink.add(loc);
  }

  void dispose() {
    _locationController.close();
  }
}
