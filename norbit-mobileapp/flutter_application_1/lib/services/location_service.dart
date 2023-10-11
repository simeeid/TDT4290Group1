import 'package:geolocator/geolocator.dart';
import '../blocs/connectivity/location_bloc.dart';

class LocationService {
  final LocationBloc locationBloc;

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
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      locationBloc.addLocation(Geolocator.getCurrentPosition() as Position);

    } catch (e) {
      throw Exception('Error in determining position: $e');
    }
  }
}
