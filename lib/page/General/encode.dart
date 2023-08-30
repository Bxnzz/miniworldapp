import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class EncryptData {
//for AES Algorithms

  static Encrypted? encrypted;
  static var decrypted;

  static encryptAES(plainText) {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted!.base64);
  }

  static decryptAES(plainText) {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    decrypted = encrypter.decrypt(encrypted!, iv: iv);
    print(decrypted);
  }

  //for Fernet Algorithms
  static Encrypted? fernetEncrypted;
  static var fernetDecrypted;
  static encryptFernet(plainText) {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = IV.fromLength(16);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    fernetEncrypted = encrypter.encrypt(plainText);
    print(fernetEncrypted!.base64); // random cipher text
    print(fernet.extractTimestamp(fernetEncrypted!.bytes));
  }

  static decryptFernet(plainText) {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = IV.fromLength(16);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    fernetDecrypted = encrypter.decrypt(fernetEncrypted!);
    print(fernetDecrypted);
  }
}
