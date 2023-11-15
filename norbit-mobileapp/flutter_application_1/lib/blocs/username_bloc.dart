import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for username management.
  Uses the `rxdart` package to create `UsernameBloc` class.
  Provides stream and sink for username handling.
*/

class UsernameBloc {
  final _usernameController = BehaviorSubject<String>();

  Stream<String> get usernameStream => _usernameController.stream;

  Sink<String> get usernameSink => _usernameController.sink;

  void addUsername(String username) {
    usernameSink.add(username);
  }

  void dispose() {
    _usernameController.close();
  }
}
