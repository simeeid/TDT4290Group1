import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../services/login_service.dart';
import '../services/mqtt_service.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final logInService = Provider.of<LogInService>(context, listen: false);
    final mqttService = Provider.of<MqttService>(context, listen: false);
    return ElevatedButton(
      onPressed: () async {
        Map<String, dynamic> loginResult = await logInService.signInWithWebUI();
        bool isSignedIn = loginResult['isSignedIn'];

        if (isSignedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          safePrint("Something went wrong with the login");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(250, 50),
      ),
      child: const Text(
        'Sign in with AWS',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
