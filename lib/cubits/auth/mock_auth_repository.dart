import '../../models/user_profile.dart';
import 'auth_cubit.dart';

class MockAuthRepository implements AuthRepository {
  UserProfile? _currentUser;

  @override
  Future<UserProfile> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Accept any credentials in mock mode
    _currentUser = UserProfile(
      uid: 'mock-uid-001',
      email: email,
      displayName: email.split('@').first,
      biometricEnabled: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<UserProfile> createUserWithEmailAndPassword(
      String email, String password, String displayName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserProfile(
      uid: 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      biometricEnabled: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<UserProfile?> getCurrentUser() async => _currentUser;

  @override
  Future<bool> authenticateWithBiometrics() async => false;
}
