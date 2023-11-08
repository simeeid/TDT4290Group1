import 'dart:async';
import 'package:rxdart/rxdart.dart';

class TokenBloc {
  final tokenController = BehaviorSubject<String>();

  Stream<String> get tokenStream => tokenController.stream;
  Sink<String> get tokenSink => tokenController.sink;

  void addToken(String token) {
    tokenSink.add(token);
  }

  void dispose() {
    tokenController.close();
  }
}