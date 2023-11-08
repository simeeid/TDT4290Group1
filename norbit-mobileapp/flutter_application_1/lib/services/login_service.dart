import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../blocs/connectivity/token_bloc.dart';
import '../blocs/connectivity/username_bloc.dart';

class LogInService {
  String? idToken;
  String? username;
  final UsernameBloc usernameBloc;
  final TokenBloc tokenBloc;

  LogInService({required this.usernameBloc, required this.tokenBloc}) {
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
      final currentUser = await Amplify.Auth.getCurrentUser();
      username = currentUser.username;
      final session = await Amplify.Auth.fetchAuthSession(
          options: const FetchAuthSessionOptions());
      idToken = (session as CognitoAuthSession)
          .userPoolTokensResult
          .value
          .idToken
          .raw;
      safePrint('This is idToken: $idToken');
      safePrint('This is username: $username');
      tokenBloc.addToken(idToken!);
      usernameBloc.addUsername(username!);

      if (session.isSignedIn) {
        return {'isSignedIn': session.isSignedIn, 'jwt': idToken};
      } else {
        return {'isSignedIn': false, 'jwt': null};
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      return {'isSignedIn': false, 'jwt': null};
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
