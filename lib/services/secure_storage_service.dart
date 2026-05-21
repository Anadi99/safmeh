import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted local storage using flutter_secure_storage.
/// All user data stored locally is encrypted at rest.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Store a string value securely.
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a string value from secure storage.
  static Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  /// Delete a value from secure storage.
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all values from secure storage.
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Store a JSON-serializable object securely.
  static Future<void> writeJson(String key, Map<String, dynamic> value) async {
    await write(key, jsonEncode(value));
  }

  /// Read a JSON object from secure storage.
  static Future<Map<String, dynamic>?> readJson(String key) async {
    final raw = await read(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

/// Keys used for secure storage.
class SecureStorageKeys {
  static const String userProfile = 'user_profile';
  static const String appConfig = 'app_config';
  static const String pretendModePin = 'pretend_mode_pin';
  static const String biometricEnabled = 'biometric_enabled';
  static const String authToken = 'auth_token';
}
