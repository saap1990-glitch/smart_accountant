import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'user_pin';
  static const _sessionKey = 'remember_session';
  static const _recoveryKey = 'recovery_code';
  static const _biometricKey = 'biometric_enabled';

  final _localAuth = LocalAuthentication();

  // ====== البصمة ======
  Future<bool> isBiometricAvailable() async {
    return await _localAuth.isDeviceSupported();
  }

  Future<bool> isBiometricEnabled() async {
    return await _storage.read(key: _biometricKey) == 'true';
  }

  Future<void> enableBiometric(bool enable) async {
    await _storage.write(key: _biometricKey, value: enable.toString());
  }

  Future<bool> authenticateWithBiometric() async {
    try {
      final available = await _localAuth.isDeviceSupported();
      if (!available) return false;
      return await _localAuth.authenticate(
        localizedReason: 'استخدم بصمة إصبعك للدخول',
        biometricOnly: true,
      );
    } catch (_) {
      return false;
    }
  }

  // ====== الرقم السري ======
  Future<void> setPin(String pin) async =>
      await _storage.write(key: _pinKey, value: pin);
  Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _pinKey);
    return stored == pin;
  }

  Future<bool> hasPin() async {
    final stored = await _storage.read(key: _pinKey);
    return stored != null && stored.isNotEmpty;
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    if (await verifyPin(oldPin)) {
      await _storage.write(key: _pinKey, value: newPin);
      return true;
    }
    return false;
  }

  // ====== رمز الاسترداد ======
  Future<void> setRecoveryCode(String code) async =>
      await _storage.write(key: _recoveryKey, value: code);
  Future<bool> verifyRecoveryCode(String code) async {
    final stored = await _storage.read(key: _recoveryKey);
    return stored == code;
  }

  Future<bool> resetPinWithRecovery(String code, String newPin) async {
    if (await verifyRecoveryCode(code)) {
      await _storage.write(key: _pinKey, value: newPin);
      return true;
    }
    return false;
  }

  // ====== الجلسة ======
  Future<void> rememberSession(bool remember) async =>
      await _storage.write(key: _sessionKey, value: remember.toString());
  Future<bool> isSessionRemembered() async {
    final stored = await _storage.read(key: _sessionKey);
    return stored == 'true';
  }

  Future<void> logout() async => await _storage.delete(key: _sessionKey);
}
