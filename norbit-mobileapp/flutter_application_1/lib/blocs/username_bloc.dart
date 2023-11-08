import 'dart:async';
import 'package:rxdart/rxdart.dart';

class UsernameBloc {
  final usernameController = BehaviorSubject<String>();

  Stream<String> get usernameStream => usernameController.stream;
  Sink<String> get usernameSink => usernameController.sink;

  void addUsername(String username) {
    usernameSink.add(username);
  }

  void dispose() {
    usernameController.close();
  }
}