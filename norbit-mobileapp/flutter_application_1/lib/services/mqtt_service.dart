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
import 'package:path_provider/path_provider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'package:http/http.dart' as http;

class MqttService {
  final NoiseBloc noiseBloc;
  final LuxBloc luxBloc;
  final AccelerometerBloc accelerometerBloc;
  final LocationBloc locationBloc;
  final storage = FlutterSecureStorage();
  String statusText = "Status Text";
  bool isConnected = false;
  StreamSubscription? luxSubscription;
  StreamSubscription? noiseSubscription;
  StreamSubscription? accelerometerSubscription;

  // Initializes client. To use own AWS account: Change string to link under mqtt test client, connection details, endpoint.
  final MqttServerClient client =
      MqttServerClient('a3rrql8lkbz9rt-ats.iot.eu-north-1.amazonaws.com', '');

  final _amplifyInstance = Amplify;

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  MqttService(
      {required this.noiseBloc,
      required this.luxBloc,
      required this.accelerometerBloc,
      required this.locationBloc});

  //runs on button click. Mostly user experience. Spinning-wheel-loading thing while waiting for connection.
  connect() async {
    isConnected = await mqttConnect("device_137");
  }

  //Disconnects from mqtt broker.
  disconnect() {
    luxSubscription?.cancel();
    client.disconnect();
  }

  Future<void> registerDevice() async {
    try {
      final cognitoPlugin =
      Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();

      final identityId = result.identityIdResult.value;
      final idToken = result.userPoolTokensResult.value.accessToken.toJson();
      safePrint("Current user's identity ID: $identityId");
      safePrint("Current user's JWT idToken: $idToken");
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
    }
  } 

  Future<void> fetchCognitoAuthSession() async {
    try {
      final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
      final identityId = result.identityIdResult.value;
      safePrint("Current user's identity ID: $identityId");
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
    }
  }


  //code for connecting to mqtt broker.
  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting MQTT Broker");
    String? certificatePemUnloaded = await storage.read(key: 'certificatePem');
    String? rootCAUnloaded = await storage.read(key: 'rootCA');
    String? privateKeyUnloaded = await storage.read(key: 'privateKey');
    safePrint("Look here $privateKeyUnloaded");
    
    if (rootCAUnloaded != null && certificatePemUnloaded != null && privateKeyUnloaded != null) {
      String rootCAPath = await createAssetFile(rootCAUnloaded, '/assets/certificates/RootCA.pem');
      safePrint(rootCAPath);
      

      String certificatePemPath = await createAssetFile(certificatePemUnloaded, '/assets/certificates/DeviceCertificate.crt');
      safePrint(certificatePemPath);

      String privateKeyPath = await createAssetFile(privateKeyUnloaded, '/assets/certificates/Private.key');
      safePrint(privateKeyPath);
    }

    String rootCAPath = '/data/user/0/com.example.flutter_application_1/app_flutter/assets/certificates/RootCA.pem';
    String privateKeyPath = '/data/user/0/com.example.flutter_application_1/app_flutter/assets/certificates/Private.key';
    String deviceCertPath = '/data/user/0/com.example.flutter_application_1/app_flutter/assets/certificates/DeviceCertificate.crt';

    ByteData rootCA = await rootBundle.load(rootCAPath);
    ByteData deviceCert =
    await rootBundle.load(deviceCertPath);
    ByteData privateKey =
    await rootBundle.load(privateKeyPath);

    List<int> rootCABytes = await File(rootCAPath).readAsBytes();
    List<int> privateKeyBytes = await File(privateKeyPath).readAsBytes();
    List<int> deviceCertBytes = await File(deviceCertPath).readAsBytes();

    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(rootCABytes);
    context.useCertificateChainBytes(deviceCertBytes);
    context.usePrivateKeyBytes(privateKeyBytes);

    client.securityContext = context;


    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
      setStatus("Connected to AWS Successfully!");
    } else {
      return false;
    }

    //Subscribed topic.
    const topic = 'main/topic';
    client.subscribe(topic, MqttQos.atMostOnce);

    return true;
  }

  void setStatus(String content) {
    statusText = content;
    safePrint(statusText);
    // Notify your listeners here
  }

  void publishLuxData() {
    const topic = 'lux/topic'; // Change this to your desired topic
    luxSubscription = luxBloc.luxController.stream.listen((luxData) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode({
        'sensorName': 'Lux Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'lux': luxData,
        }
      })); // Encode the data as a JSON string
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    });
  }

  void publishNoiseData() {
    const noiseTopic = 'noise/topic'; // Change this to your desired topic
    noiseSubscription = noiseBloc.noiseController.stream.listen((noiseData) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode({
        'sensorName': 'Noise Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'volume': noiseData,
        }
      })); // Encode the data as a JSON string
      client.subscribe(noiseTopic, MqttQos.atMostOnce);
      client.publishMessage(noiseTopic, MqttQos.atLeastOnce, builder.payload!);
    });
  }

  void publishAccelerometerData() {
    List<String> accelerometerList = [];
    const accelerometerTopic =
        'accelerometer/topic'; // Change this to your desired topic
    accelerometerSubscription = accelerometerBloc.accelerometerController.stream
        .listen((accelerometerData) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      accelerometerList.add(accelerometerData.x.toStringAsFixed(2));
      accelerometerList.add(accelerometerData.y.toStringAsFixed(2));
      accelerometerList.add(accelerometerData.z.toStringAsFixed(2));
      builder.addString(jsonEncode({
        'sensorName': 'Accelerometer Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'x': accelerometerData.x,
          'y': accelerometerData.y,
          'z': accelerometerData.z,
        }
      })); // Encode the data as a JSON string
      client.subscribe(accelerometerTopic, MqttQos.atMostOnce);
      client.publishMessage(
          accelerometerTopic, MqttQos.atLeastOnce, builder.payload!);
    });
  }

  Future<http.Response> getCreds(token) {
    final username = "antonhs";
    final modelVersion = "model_002";
    final deviceName = "device_137";
    final accessToken = token;
    final deviceId = 'device_137';

    return http.post(
      Uri.parse('https://9wixxl72v8.execute-api.eu-north-1.amazonaws.com/beta/deviceManagement/${deviceId}'),
      headers: <String, String>{
        'Authorization': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'identityId': username,
        'modelVersion': modelVersion,
        'deviceName': deviceName,
      }),
    );
  }

  void onConnected() {
    setStatus("Client connection was successful");
    print("Client connection was successful");
    // Notify your listeners here
  }

  void onDisconnected() {
    print('Disconnected');
    // Add any additional logic here
    // Notify your listeners here
  }

  void pong() {
    print('Ping response client callback invoked');
    // Add any additional logic here
    // Notify your listeners here
  }

  Future<String> createAssetFile(String fileContent, String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}$filePath');
    safePrint("Lookie: $file");
    safePrint("Lookie: $directory");
    await file.writeAsString(fileContent, mode: FileMode.write);
    return file.path;
  }
}

