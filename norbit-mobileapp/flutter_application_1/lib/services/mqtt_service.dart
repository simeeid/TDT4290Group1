import 'package:flutter_application_1/blocs/connectivity/accelerometer_bloc.dart';
import '../blocs/connectivity/lux_bloc.dart';
import '../blocs/connectivity/noise_bloc.dart';

class MqttService {
  final NoiseBloc noiseBloc;
  final LuxBloc luxBloc;
  final AccelerometerBloc accelerometerBloc;

  MqttService({required this.noiseBloc, required this.luxBloc, required this.accelerometerBloc});
}