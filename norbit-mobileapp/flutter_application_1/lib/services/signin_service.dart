import 'dart:io';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:flutter_application_1/blocs/connectivity/location_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/noise_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInService{
    final String username;
    final String password;

    SignInService({
        required this.username,
        required this.password,
    });

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

    Future<bool> isUserSignedIn() async {
        final result = await Amplify.Auth.fetchAuthSession();
        safePrint(await Amplify.Auth.fetchAuthSession());
        return result.isSignedIn;
    }

    Future<AuthUser> getCurrentUser() async {
        final user = await Amplify.Auth.getCurrentUser();
        return user;
    }


    /// Signs a user up with a username, password. The required
    /// attributes may be different depending on your app's configuration.
    Future<void> signUpUser({
        required String username,
        required String password,
        String? phoneNumber,
        }) async {
        try {
        final userAttributes = {
            if (phoneNumber != null) AuthUserAttributeKey.phoneNumber: phoneNumber,
            // additional attributes as needed
        };
        final result = await Amplify.Auth.signUp(
            username: username,
            password: password,
            options: SignUpOptions(
            userAttributes: userAttributes,
            ),
        );
        await _handleSignUpResult(result);
        } on AuthException catch (e) {
        safePrint('Error signing up user: ${e.message}');
        }
    }

    Future<void> _handleSignUpResult(SignUpResult result) async {
        switch (result.nextStep.signUpStep) {
        case AuthSignUpStep.confirmSignUp:
            final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
            _handleCodeDelivery(codeDeliveryDetails);
            break;
        case AuthSignUpStep.done:
            safePrint('Sign up is complete');
            break;
        }
    }

    Future<void> confirmUser({
        required String username,
        required String confirmationCode,
    }) async {
        try {
        final result = await Amplify.Auth.confirmSignUp(
            username: username,
            confirmationCode: confirmationCode,
        );
        // Check if further confirmations are needed or if
        // the sign up is complete.
        await _handleSignUpResult(result);
        } on AuthException catch (e) {
        safePrint('Error confirming user: ${e.message}');
        }
    }




    //call when user has entered username and password
    Future<bool> signInUser(String username, String password) async {
        try {
        final result = await Amplify.Auth.signIn(
            username: username,
            password: password,
        );

        await _handleSignInResult(result);
        return true;
        } on AuthException catch (e) {
        safePrint('Error signing in: ${e.message}');
        }
        return false;
    }

    Future<void> _handleSignInResult(SignInResult result) async {
        switch (result.nextStep.signInStep) {
        case AuthSignInStep.confirmSignInWithSmsMfaCode:
            final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
            _handleCodeDelivery(codeDeliveryDetails);
            break;
        case AuthSignInStep.confirmSignInWithNewPassword:
            safePrint('Enter a new password to continue signing in');
            break;
        case AuthSignInStep.confirmSignInWithCustomChallenge:
            final parameters = result.nextStep.additionalInfo;
            final prompt = parameters['prompt']!;
            safePrint(prompt);
            break;
        //case AuthSignInStep.resetPassword:
        //    final resetResult = await Amplify.Auth.resetPassword(
        //    username: username,
        //    );
        //    await _handleResetPasswordResult(resetResult);
        //    break;
        case AuthSignInStep.confirmSignUp:
            // Resend the sign up code to the registered device.
            final resendResult = await Amplify.Auth.resendSignUpCode(
            username: username,
            );
            _handleCodeDelivery(resendResult.codeDeliveryDetails);
            break;
        case AuthSignInStep.done:
            safePrint('Sign in is complete');
            break;
        default:
            safePrint('An unhandled sign in step occurred: ${result.nextStep.signInStep}');
        }

        }


    void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
        safePrint(
        'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
        'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
        );
    }
}
