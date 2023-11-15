import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/device_name_bloc.dart';

void main() {
  group('DeviceNameBloc', () {
    late DeviceNameBloc deviceNameBloc;

    setUp(() {
      deviceNameBloc = DeviceNameBloc();
    });

    tearDown(() {
      deviceNameBloc.dispose();
    });

    test('DeviceNameStream emits [] when nothing is added', () {
      expectLater(
        deviceNameBloc.deviceNameStream,
        emitsInOrder([]),
      );
    });

    test('DeviceNameStream emits the last value added when listening',
        () async {
      deviceNameBloc.addDeviceName('deviceName');
      expect(deviceNameBloc.deviceNameStream, emits('deviceName'));
    });
  });
}
