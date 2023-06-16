import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalBiometrics {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometric() async {
    return await _auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometric();

    if (!isAvailable) {
      return false;
    } else {
      try {
        return await _auth.authenticate(
          localizedReason: 'Use sua digital para desbloquear o acesso',
          options: AuthenticationOptions(
            sensitiveTransaction: true,
            biometricOnly: false,
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );
      } on PlatformException catch (e) {
        return false;
      }
    }
  }
}
