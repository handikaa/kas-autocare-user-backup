import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../core/utils/secure_encryptor.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  final _storage = const FlutterSecureStorage();
  final _encryptor = SecureEncryptor();

  Future<void> saveEncrypted(String key, String value) async {
    final encrypted = _encryptor.encryptText(value);
    await _storage.write(key: key, value: encrypted);
  }

  Future<String?> readDecrypted(String key) async {
    String? encryptedValue;

    try {
      // 👇 TANGKAP ERROR DI SINI JUGA
      encryptedValue = await _storage.read(key: key);
    } catch (e, s) {
      await _storage.delete(key: key);
      await Sentry.captureException(e, stackTrace: s);
      return null;
    }

    if (encryptedValue == null || encryptedValue.isEmpty) {
      return null;
    }

    try {
      return _encryptor.decryptText(encryptedValue);
    } catch (e, s) {
      await _storage.delete(key: key);
      await Sentry.captureException(e, stackTrace: s);
      return null;
    }
  }

  Future<void> delete(String key) async => await _storage.delete(key: key);

  Future<void> clearAll() async => await _storage.deleteAll();
}
