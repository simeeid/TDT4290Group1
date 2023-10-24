import 'package:flutter/material.dart';
import '../widgets/signin_button_widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  // Define the controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Norbit mobile app'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController, // Use the controller
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController, // Use the controller
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            SignInButton(
              usernameController: _usernameController,
              passwordController: _passwordController,
            ),
          ],
        ),
      ),
    );
  }
}
