import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LogInService {
  LogInService() {
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      AmplifyAuthCognito auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  Future<bool> signInWithWebUI() async {
    try {
      final creds = await Amplify.Auth.fetchAuthSession();
      safePrint('Sign in result: $creds');
      return true;
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      return false;
    }
  }

  Future<void> signOutWithWebUI() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }
}
