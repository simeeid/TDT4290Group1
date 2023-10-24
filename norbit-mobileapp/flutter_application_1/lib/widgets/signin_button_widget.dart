import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../services/signin_service.dart';
import '../screens/signin_screen.dart';
import '../services/login_service.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key, required this.usernameController, required this.passwordController});

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final LogInService logInService = LogInService();
    return ElevatedButton(
      onPressed: () async {
        logInService.signInWithWebUI();
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