import 'package:flutter/material.dart';
import '../widgets/signin_button_widget.dart';

/*
This is the sign in screen. Contains one button: sign in with AWS.
 */

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Norbit mobile app'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(),
          ],
        ),
      ),
    );
  }
}
