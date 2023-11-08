import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/location_bloc.dart';
import 'package:geolocator/geolocator.dart';

/*
LocationWidget uses the data in the stream of the location bloc.
It updates the location data on the users screen based on this data.
It displays latitude and longitude.
 */

class LocationWidget extends StatelessWidget {
  final LocationBloc locationBloc;

  const LocationWidget({Key? key, required this.locationBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: locationBloc.locationController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Latitude: ${snapshot.data!.latitude.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Longitude: ${snapshot.data!.longitude.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
