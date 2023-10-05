import 'package:flutter/material.dart';

class LuxWidget extends StatelessWidget {
  final double? luxValue;

  const LuxWidget({super.key, required this.luxValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Lux value: $luxValue lx'),
      ],
    );
  }
}
