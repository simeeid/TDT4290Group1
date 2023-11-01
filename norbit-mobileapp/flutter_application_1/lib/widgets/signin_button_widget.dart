import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../services/login_service.dart';
import '../services/mqtt_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final logInService = Provider.of<LogInService>(context, listen: false);
    final mqttService = Provider.of<MqttService>(context, listen: false);
    final storage = FlutterSecureStorage();
    return ElevatedButton(
      onPressed: () async {
        Map<String, dynamic> loginResult = await logInService.signInWithWebUI();
        bool isSignedIn = loginResult['isSignedIn'];
        String? jwt = loginResult['jwt'];

        if(jwt != null) {
          final creds = await mqttService.getCreds(jwt);
          final credsyo = jsonDecode(creds.body);
          safePrint("Device Name:  ${credsyo['data']['deviceName']}");
          await storage.write(key: 'certificatePem', value: credsyo['data']['certificatePem']);
          await storage.write(key: 'rootCA', value: credsyo['data']['rootCA']);
          await storage.write(key: 'deviceName', value: credsyo['data']['deviceName']);
          await storage.write(key: 'privateKey', value: credsyo['data']['privateKey']);

          safePrint("Pem: ${credsyo['data']['certificatePem']}");
          safePrint("Root CA: ${credsyo['data']['rootCA']}");
          safePrint("Private key: ${credsyo['data']['privateKey']}");
        }

        if(isSignedIn){
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
        'Sign in with AWS',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}