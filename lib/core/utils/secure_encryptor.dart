import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

class SecureEncryptor {
  final _key = encrypt.Key.fromUtf8(
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456",
  ); // 32 char

  // Generate IV per-enkripsi (bukan statis)
  String encryptText(String text) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc),
    );

    final encrypted = encrypter.encrypt(text, iv: iv);

    // simpan IV + CIPHERTEXT → base64
    final combined = iv.bytes + encrypted.bytes;
    return base64Encode(combined);
  }

  String decryptText(String encryptedText) {
    final raw = base64Decode(encryptedText);

    // extract kembali IV & ciphertext
    final iv = encrypt.IV(raw.sublist(0, 16));
    final cipher = raw.sublist(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc),
    );
    return encrypter.decrypt(encrypt.Encrypted(cipher), iv: iv);
  }
}
