import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
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
        bool loginResult = await logInService.signInWithWebUI();
        if(loginResult == true){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } 
        else{
          safePrint("Something went wrong with the login");
        }
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