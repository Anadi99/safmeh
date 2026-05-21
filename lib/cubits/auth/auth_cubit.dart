import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_profile.dart';
import '../../services/password_validator.dart';
import 'auth_state.dart';

/// Abstract auth repository — swap real Firebase impl in later.
abstract class AuthRepository {
  Future<UserProfile> signInWithEmailAndPassword(String email, String password);
  Future<UserProfile> createUserWithEmailAndPassword(String email, String password, String displayName);
  Future<void> signOut();
  Future<UserProfile?> getCurrentUser();
  Future<bool> authenticateWithBiometrics();
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.signInWithEmailAndPassword(email.trim(), password);
      emit(AuthAuthenticated(user));
    } catch (_) {
      emit(const AuthError('Incorrect email or password.'));
    }
  }

  Future<void> register(String email, String password, String displayName) async {
    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      emit(AuthError(passwordError));
      return;
    }
    emit(const AuthLoading());
    try {
      final user = await _repository.createUserWithEmailAndPassword(
          email.trim(), password, displayName.trim());
      emit(AuthAuthenticated(user));
    } catch (_) {
      emit(const AuthError('Registration failed. Please try again.'));
    }
  }

  Future<void> signInWithBiometrics() async {
    emit(const AuthLoading());
    try {
      final success = await _repository.authenticateWithBiometrics();
      if (success) {
        final user = await _repository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
          return;
        }
      }
      emit(const AuthError('Biometric authentication failed.'));
    } catch (_) {
      emit(const AuthError('Biometric authentication failed.'));
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    emit(const AuthUnauthenticated());
  }
}
