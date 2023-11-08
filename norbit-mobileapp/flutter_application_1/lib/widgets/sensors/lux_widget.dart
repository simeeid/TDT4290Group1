import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/sensors/lux_bloc.dart';

/*
LuxWidget uses the data in the stream of the lux bloc.
It updates the lux data on the users screen based on this data.
It displays the light value in Lx.
 */

class LuxWidget extends StatelessWidget {
  final LuxBloc luxBloc;

  const LuxWidget({Key? key, required this.luxBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: luxBloc.luxController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'Lux level: ${snapshot.data!.toStringAsFixed(2)} Lx',
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
