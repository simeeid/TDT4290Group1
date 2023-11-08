import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for device name management.
  Uses the `rxdart` package to create `DeviceNameBloc` class.
  Provides stream and sink for device name handling.
*/

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
