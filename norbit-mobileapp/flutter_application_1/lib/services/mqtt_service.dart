import 'dart:io';
import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/noise_bloc.dart';
import 'dart:async';
import 'dart:convert';


import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final NoiseBloc noiseBloc;
  final LuxBloc luxBloc;
  final AccelerometerBloc accelerometerBloc;
  String statusText = "Status Text";
  bool isConnected = false;
  StreamSubscription? luxSubscription;
  StreamSubscription? noiseSubscription;
  StreamSubscription? accelerometerSubscription;

  // Initializes client. To use own AWS account: Change string to link under mqtt test client, connection details, endpoint.
  final MqttServerClient client =
      MqttServerClient('a3rrql8lkbz9rt-ats.iot.eu-north-1.amazonaws.com', '');

  MqttService({required this.noiseBloc, required this.luxBloc, required this.accelerometerBloc});

  //runs on button click. Mostly user experience. Spinning-wheel-loading thing while waiting for connection.
  connect() async {
      isConnected = await mqttConnect("123");
    }

  //Disconnects from mqtt broker.
  disconnect() {
    luxSubscription?.cancel();
    client.disconnect();
  }

  //code for connecting to mqtt broker.
  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    ByteData rootCA = await rootBundle.load('assets/certificates/RootCA.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/certificates/DeviceCertificate.crt');
    ByteData privateKey = await rootBundle.load('assets/certificates/Private.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

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
      print(statusText);
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
          'lux':luxData,
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
    const accelerometerTopic = 'accelerometer/topic'; // Change this to your desired topic
    accelerometerSubscription = accelerometerBloc.accelerometerController.stream.listen((accelerometerData) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      accelerometerList.add(accelerometerData.x.toStringAsFixed(2));
      accelerometerList.add(accelerometerData.y.toStringAsFixed(2));
      accelerometerList.add(accelerometerData.z.toStringAsFixed(2));
      builder.addString(jsonEncode({
        'sensorName': 'Accelerometer Sensor',
        'timestamp': DateTime.now().toIso8601String(),
        'payload': {
          'x':accelerometerData.x,
          'y':accelerometerData.y,
          'z':accelerometerData.z,
        }
      })); // Encode the data as a JSON string
      client.subscribe(accelerometerTopic, MqttQos.atMostOnce);
      client.publishMessage(accelerometerTopic, MqttQos.atLeastOnce, builder.payload!);
    });
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
}