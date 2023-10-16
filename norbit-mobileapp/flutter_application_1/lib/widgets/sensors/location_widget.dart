import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/connectivity/location_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationWidget extends StatelessWidget {
  final LocationBloc locationBloc;

  const LocationWidget({Key? key, required this.locationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: locationBloc.locationController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text('Latitude: ${snapshot.data!.latitude}'),
              Text('Longitude: ${snapshot.data!.longitude}'),
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