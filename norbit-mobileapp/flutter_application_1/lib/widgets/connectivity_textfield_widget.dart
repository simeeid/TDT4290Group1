import 'package:flutter/material.dart';

class ConnectivityTextField extends StatelessWidget {

  const ConnectivityTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
