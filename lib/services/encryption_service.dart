import 'dart:typed_data';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;

/// AES-256 encryption service for audio evidence and sensitive data.
/// Uses AES-CBC with a 256-bit key and random IV per encryption.
class EncryptionService {
  static const int _keyLength = 32; // 256 bits
  static const int _ivLength = 16;  // 128 bits

  /// Encrypt bytes using AES-256-CBC.
  /// Returns the IV prepended to the ciphertext.
  static Uint8List encrypt(Uint8List plaintext, Uint8List keyBytes) {
    assert(keyBytes.length == _keyLength, 'Key must be 32 bytes (256 bits)');
    final key = enc.Key(keyBytes);
    final iv = enc.IV.fromSecureRandom(_ivLength);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(plaintext, iv: iv);
    // Prepend IV to ciphertext so it can be used for decryption
    final result = Uint8List(_ivLength + encrypted.bytes.length);
    result.setRange(0, _ivLength, iv.bytes);
    result.setRange(_ivLength, result.length, encrypted.bytes);
    return result;
  }

  /// Decrypt bytes using AES-256-CBC.
  /// Expects IV prepended to ciphertext (as produced by [encrypt]).
  static Uint8List decrypt(Uint8List ivAndCiphertext, Uint8List keyBytes) {
    assert(keyBytes.length == _keyLength, 'Key must be 32 bytes (256 bits)');
    final ivBytes = ivAndCiphertext.sublist(0, _ivLength);
    final cipherBytes = ivAndCiphertext.sublist(_ivLength);
    final key = enc.Key(keyBytes);
    final iv = enc.IV(ivBytes);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final decrypted = encrypter.decryptBytes(enc.Encrypted(cipherBytes), iv: iv);
    return Uint8List.fromList(decrypted);
  }

  /// Generate a random 256-bit encryption key.
  static Uint8List generateKey() {
    return enc.Key.fromSecureRandom(_keyLength).bytes;
  }

  /// Derive a key from a passphrase using a simple hash.
  /// In production, use PBKDF2 or Argon2.
  static Uint8List deriveKey(String passphrase) {
    final bytes = utf8.encode(passphrase);
    // Pad or truncate to 32 bytes
    final key = Uint8List(_keyLength);
    for (int i = 0; i < _keyLength; i++) {
      key[i] = i < bytes.length ? bytes[i] : 0;
    }
    return key;
  }

  /// Returns true if the data appears to be encrypted (has IV prefix).
  /// This is a heuristic check — not cryptographically guaranteed.
  static bool looksEncrypted(Uint8List data) {
    return data.length > _ivLength;
  }
}
