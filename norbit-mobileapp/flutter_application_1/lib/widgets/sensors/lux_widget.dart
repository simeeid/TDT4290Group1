import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/connectivity/lux_bloc.dart';

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
              Text('Lux level: ${snapshot.data!.toStringAsFixed(2)} Lx'),
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