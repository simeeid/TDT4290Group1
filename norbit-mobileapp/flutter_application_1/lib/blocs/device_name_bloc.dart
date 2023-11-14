import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for device name management.
  Uses the `rxdart` package to create `DeviceNameBloc` class.
  Provides stream and sink for device name handling.
*/

class DeviceNameBloc {
  final _deviceNameController = BehaviorSubject<String>();

  Stream<String> get deviceNameStream => _deviceNameController.stream;

  Sink<String> get deviceNameSink => _deviceNameController.sink;

  void addDeviceName(String deviceName) {
    deviceNameSink.add(deviceName);
  }

  void dispose() {
    _deviceNameController.close();
  }
}
