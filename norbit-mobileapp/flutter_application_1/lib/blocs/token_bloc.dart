import 'dart:async';
import 'package:rxdart/rxdart.dart';

/*
  Flutter Bloc for token management.
  Uses the `rxdart` package to create `TokenBloc` class.
  Provides stream and sink for token handling.
*/

class TokenBloc {
  final _tokenController = BehaviorSubject<String>();

  Stream<String> get tokenStream => _tokenController.stream;

  Sink<String> get tokenSink => _tokenController.sink;

  void addToken(String token) {
    tokenSink.add(token);
  }

  void dispose() {
    _tokenController.close();
  }
}
