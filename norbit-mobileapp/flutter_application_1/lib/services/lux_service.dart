import 'dart:async';
import 'package:flutter_application_1/blocs/connectivity/lux_bloc.dart';

class LuxService {
  LuxService({required LuxBloc luxBloc}) {
    luxBloc.addLux(8);
  }
  void TestService() {
    print("service is connected");
  }
}