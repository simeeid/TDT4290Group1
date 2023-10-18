import 'dart:async';

import 'package:geolocator/geolocator.dart';
import '../blocs/connectivity/location_bloc.dart';

class LocationService {
  final LocationBloc locationBloc;
  late StreamSubscription<Position> positionStream;

  LocationService({required this.locationBloc});

  Future<void> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position currentLocation = await Geolocator.getCurrentPosition();
      locationBloc.addLocation(currentLocation);

    } catch (e) {
      throw Exception('Error in determining position: $e');
    }
  }

  void start() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Set your desired distance filter
    );
    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position? position) {
      if (position != null) {
        locationBloc.addLocation(position);
      }
    });
  }

  void stop() {
    positionStream.cancel();
  }
}
