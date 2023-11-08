import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/blocs/username_bloc.dart';

void main() {
  group('UsernameBloc', () {
    late UsernameBloc usernameBloc;

    setUp(() {
      usernameBloc = UsernameBloc();
    });

    tearDown(() {
      usernameBloc.dispose();
    });

    test('UsernameStream emits [] when nothing is added', () {
      expectLater(
        usernameBloc.usernameStream,
        emitsInOrder([]),
      );
    });

    test('UsernameStream emits the last value added when listening', () async {
      usernameBloc.addUsername('username');
      expect(usernameBloc.usernameStream, emits('username'));
    });
  });
}
