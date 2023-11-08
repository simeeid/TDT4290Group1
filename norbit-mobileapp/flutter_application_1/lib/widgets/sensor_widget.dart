import 'package:flutter/material.dart';

/*
SensorWidget is a box for displaying the sensor widgets,
making sure all sensor data is displayed in the same format.
 */

class SensorWidget extends StatelessWidget {
  final Widget child;
  final String title;

  const SensorWidget({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 10.0),
          child,
        ],
      ),
    );
  }
}
