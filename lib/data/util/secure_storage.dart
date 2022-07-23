import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyCode = 'passcode';

  static Future setPasscode(String passcode) async {
    return await _storage.write(key: _keyCode, value: passcode);
  }

  static Future<String?> getPassCode() async {
    return await _storage.read(key: _keyCode);
  }

  static Future deletePassCode() async {
    return await _storage.delete(key: _keyCode);
  }
}
