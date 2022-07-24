import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> isSupported() async {
    try {
      return _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
          localizedReason: "Use Fingerprint or Face to Unlock",
          options: const AuthenticationOptions(
              stickyAuth: true,
              useErrorDialogs: true,
              biometricOnly: true,
              sensitiveTransaction: true));
    } on PlatformException catch (e) {
      return false;
    }
  }
}
