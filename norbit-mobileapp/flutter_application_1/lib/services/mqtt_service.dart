import 'dart:io';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import 'package:flutter_application_1/blocs/connectivity/location_bloc.dart';
import 'package:flutter_application_1/services/save_service.dart';
import '../blocs/connectivity/device_name_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/noise_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../amplifyconfiguration.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import '../blocs/connectivity/username_bloc.dart';

class MqttService {
  final UsernameBloc usernameBloc;
  final DeviceNameBloc deviceNameBloc;
  final NoiseBloc noiseBloc;
  final LuxBloc luxBloc;
  final AccelerometerBloc accelerometerBloc;
  final LocationBloc locationBloc;
  String statusText = "Status Text";
  bool isConnected = false;
  StreamSubscription? luxSubscription;
  StreamSubscription? noiseSubscription;
  StreamSubscription? accelerometerSubscription;
  StreamSubscription? locationSubscription;
  StreamSubscription? usernameSubscription;
  StreamSubscription? deviceNameSubscription;
  bool luxEnable = true;
  bool soundEnable = true;
  bool temperatureEnable = true;
  bool accelerometerEnable = true;
  bool gpsEnable = true;

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
      {required this.usernameBloc,
      required this.deviceNameBloc,
      required this.noiseBloc,
      required this.luxBloc,
      required this.accelerometerBloc,
      required this.locationBloc});

  connect() async {
    isConnected = await mqttConnect();
  }

  disconnect() {
    luxSubscription?.cancel();
    noiseSubscription?.cancel();
    accelerometerSubscription?.cancel();
    locationSubscription?.cancel();
    client.disconnect();
  }

  Future<void> fetchCognitoAuthSession() async {
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
    }
  }

  void setStatus(String content) {
    statusText = content;
    safePrint(statusText);
  }

  void onConnected() {
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      Map<String, dynamic> sensorStates = jsonDecode(pt);
      if (!sensorStates.containsKey("type") ||
          sensorStates["type"] != "sensor-state-config") {
        return;
      }
      luxEnable = sensorStates['light'];
      soundEnable = sensorStates['sound'];
      accelerometerEnable = sensorStates['accelerometer'];
      gpsEnable = sensorStates['location'];
    });
  }

  Future<bool> mqttConnect() async {
    setStatus("Connecting MQTT Broker");
    ByteData deviceCert, privateKey;

    fetchCognitoAuthSession();
    final saveService = SaveService();

    ByteData rootCA = await rootBundle.load('assets/certificates/RootCA.pem');

    final String? deviceCertData = await saveService.readStringFromFile('certificate.txt');
    if (deviceCertData != null) {
      List<int> certList = utf8.encode(deviceCertData);
      deviceCert = ByteData.sublistView(Uint8List.fromList(certList));
    }
    else {
      return false;
    }
    final String? privateKeyData = await saveService.readStringFromFile('privateKey.txt');
    if (privateKeyData != null) {
      List<int> keyList = utf8.encode(privateKeyData);
      privateKey = ByteData.sublistView(Uint8List.fromList(keyList));
    }
    else {
      return false;
    }
    SecurityContext context = SecurityContext.defaultContext;
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());

    client.securityContext = context;

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;

    final usernameData = await usernameBloc.usernameController.stream.first;
    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(usernameData).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      setStatus("Connected to AWS Successfully!");
    } else {
      return false;
    }
    return true;
  }

  Future<String> getTopic() async {
    String usernameValue = '';
    String deviceNameValue = '';
    final usernameData = await usernameBloc.usernameController.stream.first;
    usernameValue = usernameData;
    final deviceNameData =
        await deviceNameBloc.deviceNameController.stream.first;
    deviceNameValue = deviceNameData;
    safePrint('THIS IS USER AND DEVIVE NAME $usernameValue $deviceNameValue');
    safePrint('THIS IS IT $usernameValue/$deviceNameValue');
    return "$usernameValue/$deviceNameValue";
  }

  Future<void> publishLuxData() async {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      safePrint("Client is not connected. Cannot publish.");
      return;
    }
    String topic = await getTopic();
    final luxTopic = '$topic/lux';
    safePrint('THIS IS LUX TOPIC: $luxTopic');
    luxSubscription = luxBloc.luxController.stream.listen((luxData) {
      safePrint('LISTENING WORKS');
      if (!luxEnable) {
        safePrint('LYX NOT ENABLED');
        return;
      }
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      safePrint('BUILDER WORKS');
      builder.addString(jsonEncode({
        'sensorName': 'Lux Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'lux': luxData,
        }
      }));
      safePrint('JSON WORKS');
      client.publishMessage(luxTopic, MqttQos.atLeastOnce, builder.payload!);
      safePrint('PUBLISH WORKS');
    });
  }

  Future<void> publishNoiseData() async {
    String topic = await getTopic();
    final noiseTopic = '$topic/noise';
    noiseSubscription = noiseBloc.noiseController.stream.listen((noiseData) {
      if (!soundEnable) {
        return;
      }
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode({
        'sensorName': 'Noise Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'volume': noiseData,
        }
      })); // Encode the data as a JSON string
      //client.subscribe(noiseTopic, MqttQos.atMostOnce);
      client.publishMessage(noiseTopic, MqttQos.atLeastOnce, builder.payload!);
    });
  }

  Future<void> publishAccelerometerData() async {
    List<String> accelerometerList = [];
    String topic = await getTopic();
    final accelerometerTopic = '$topic/accelerometer';
    accelerometerSubscription = accelerometerBloc.accelerometerController.stream
        .listen((accelerometerData) {
      if (!accelerometerEnable) {
        return;
      }
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
      //client.subscribe(accelerometerTopic, MqttQos.atMostOnce);
      client.publishMessage(
          accelerometerTopic, MqttQos.atLeastOnce, builder.payload!);
    });
  }

  Future<void> publishLocationData() async {
    String topic = await getTopic();
    final locationTopic = '$topic/location';
    locationBloc.locationController.stream.listen((locationData) {
      if (!gpsEnable) {
        return;
      }
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode({
        'sensorName': 'Location Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        }
      })); // Encode the data as a JSON string
      //client.subscribe(locationTopic, MqttQos.atMostOnce);
      client.publishMessage(
          locationTopic, MqttQos.atLeastOnce, builder.payload!);
    });
  }

  Future<void> publishController() async {
    await publishLuxData();
    await publishNoiseData();
    await publishAccelerometerData();
    await publishLocationData();
  }
}
