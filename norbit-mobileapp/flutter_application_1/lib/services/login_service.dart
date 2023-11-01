import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

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

  Future<Map<String, dynamic>> signInWithWebUI() async {
    try {
      final result = await Amplify.Auth.signInWithWebUI();
      final session = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions()
      );
      final idToken = (session as CognitoAuthSession).userPoolTokensResult.value.idToken.raw;
      safePrint('idToken: $idToken');

      String encodeBase64(dynamic json){
        String jsonString = jsonEncode(json);
        String base64String = base64UrlEncode(utf8.encode(jsonString));
        return base64String;
      }
      if (session.isSignedIn) {
        fetchCognitoAuthSession();
        return {'isSignedIn': session.isSignedIn, 'jwt': idToken};
      }
      else {
        return {'isSignedIn': false, 'jwt': null};
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      return {'isSignedIn': false, 'jwt': null};
    }
  }

  Future<void> fetchCognitoAuthSession() async {
    try {
      final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
      final accessToken = result;
      final identityId = result.identityIdResult.value;
      safePrint("Current user's identity ID: $identityId");
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
    }
  }

  Future<void> signOutWithWebUI() async {
    try {
      await Amplify.Auth.signOut();
      safePrint("Signed out successfully");
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }
}

