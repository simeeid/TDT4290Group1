import 'dart:async';
import 'package:rxdart/rxdart.dart';

class DeviceNameBloc {
  final deviceNameController = BehaviorSubject<String>();

  Stream<String> get deviceNameStream => deviceNameController.stream;
  Sink<String> get deviceNameSink => deviceNameController.sink;

  void addDeviceName(String deviceName) {
    deviceNameSink.add(deviceName);
  }

  void dispose() {
    deviceNameController.close();
  }
}