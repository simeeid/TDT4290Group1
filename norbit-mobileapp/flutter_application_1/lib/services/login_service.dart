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

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../amplifyconfiguration.dart';

class LogInService{

    LogInService(){
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

    Future<void> signInWithWebUI() async {
        try {
            final result = await Amplify.Auth.signInWithWebUI();
            final creds = await Amplify.Auth.fetchAuthSession();
            safePrint('Sign in result: $creds');
        } on AuthException catch (e) {
            safePrint('Error signing in: ${e.message}');
        }
    }


}
