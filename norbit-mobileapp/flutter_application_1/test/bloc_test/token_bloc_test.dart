import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/token_bloc.dart';

void main() {
  group('TokenBloc', () {
    late TokenBloc tokenBloc;

    setUp(() {
      tokenBloc = TokenBloc();
    });

    tearDown(() {
      tokenBloc.dispose();
    });

    test('TokenStream emits [] when nothing is added', () {
      expectLater(
        tokenBloc.tokenStream,
        emitsInOrder([]),
      );
    });

    test('TokenStream emits the last value added when listening', () async {
      tokenBloc.addToken('token');
      expect(tokenBloc.tokenStream, emits('token'));
    });
  });
}
