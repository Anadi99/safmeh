import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/auth/auth.dart';
import 'package:safmeh/services/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    test('rejects password shorter than 8 chars', () {
      expect(PasswordValidator.isValid('Ab1'), isFalse);
    });

    test('rejects password without uppercase', () {
      expect(PasswordValidator.isValid('abcdefg1'), isFalse);
    });

    test('rejects password without lowercase', () {
      expect(PasswordValidator.isValid('ABCDEFG1'), isFalse);
    });

    test('rejects password without digit', () {
      expect(PasswordValidator.isValid('Abcdefgh'), isFalse);
    });

    test('accepts valid password', () {
      expect(PasswordValidator.isValid('SafMeh123'), isTrue);
    });
  });

  group('AuthCubit', () {
    late AuthCubit cubit;

    setUp(() {
      cubit = AuthCubit(MockAuthRepository());
    });

    tearDown(() => cubit.close());

    test('initial state is AuthInitial', () {
      expect(cubit.state, isA<AuthInitial>());
    });

    test('signIn emits AuthAuthenticated on success', () async {
      await cubit.signIn('test@example.com', 'Password1');
      expect(cubit.state, isA<AuthAuthenticated>());
    });

    test('register emits AuthError for weak password', () async {
      await cubit.register('test@example.com', 'weak', 'Test User');
      expect(cubit.state, isA<AuthError>());
    });

    test('register emits AuthAuthenticated for valid credentials', () async {
      await cubit.register('test@example.com', 'SafMeh123', 'Test User');
      expect(cubit.state, isA<AuthAuthenticated>());
    });

    test('signOut emits AuthUnauthenticated', () async {
      await cubit.signIn('test@example.com', 'Password1');
      await cubit.signOut();
      expect(cubit.state, isA<AuthUnauthenticated>());
    });
  });
}
