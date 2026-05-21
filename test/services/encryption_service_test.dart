import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/services/encryption_service.dart';

void main() {
  group('EncryptionService', () {
    test('generateKey produces 32-byte key', () {
      final key = EncryptionService.generateKey();
      expect(key.length, 32);
    });

    test('deriveKey produces 32-byte key', () {
      final key = EncryptionService.deriveKey('test-passphrase');
      expect(key.length, 32);
    });

    test('encrypt produces output longer than input', () {
      final key = EncryptionService.generateKey();
      final plaintext = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
      final encrypted = EncryptionService.encrypt(plaintext, key);
      expect(encrypted.length, greaterThan(plaintext.length));
    });

    test('encrypt then decrypt round-trip', () {
      final key = EncryptionService.generateKey();
      final plaintext = Uint8List.fromList(List.generate(64, (i) => i));
      final encrypted = EncryptionService.encrypt(plaintext, key);
      final decrypted = EncryptionService.decrypt(encrypted, key);
      expect(decrypted, plaintext);
    });

    test('different keys produce different ciphertext', () {
      final key1 = EncryptionService.generateKey();
      final key2 = EncryptionService.generateKey();
      final plaintext = Uint8List.fromList(List.generate(32, (i) => i));
      final enc1 = EncryptionService.encrypt(plaintext, key1);
      final enc2 = EncryptionService.encrypt(plaintext, key2);
      expect(enc1, isNot(enc2));
    });

    test('looksEncrypted returns true for encrypted data', () {
      final key = EncryptionService.generateKey();
      final plaintext = Uint8List.fromList(List.generate(32, (i) => i));
      final encrypted = EncryptionService.encrypt(plaintext, key);
      expect(EncryptionService.looksEncrypted(encrypted), isTrue);
    });

    test('looksEncrypted returns false for short data', () {
      final shortData = Uint8List.fromList([1, 2, 3]);
      expect(EncryptionService.looksEncrypted(shortData), isFalse);
    });

    test('audio segment encryption round-trip', () {
      // Simulate encrypting an audio segment before upload
      final key = EncryptionService.generateKey();
      final audioData = Uint8List.fromList(List.generate(1024, (i) => i % 256));
      final encrypted = EncryptionService.encrypt(audioData, key);
      // Verify it looks encrypted (has IV prefix)
      expect(EncryptionService.looksEncrypted(encrypted), isTrue);
      // Verify round-trip
      final decrypted = EncryptionService.decrypt(encrypted, key);
      expect(decrypted, audioData);
    });
  });
}
