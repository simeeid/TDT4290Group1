import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        minimumSize: const Size(250, 50),
      ),
      child: const Text(
        'Sign in',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}