import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'user_pin';
  static const _sessionKey = 'remember_session';
  static const _recoveryKey = 'recovery_code';

  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

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

  Future<void> setRecoveryCode(String code) async {
    await _storage.write(key: _recoveryKey, value: code);
  }

  Future<bool> verifyRecoveryCode(String code) async {
    final stored = await _storage.read(key: _recoveryKey);
    return stored == code;
  }

  Future<bool> resetPinWithRecovery(String recoveryCode, String newPin) async {
    if (await verifyRecoveryCode(recoveryCode)) {
      await _storage.write(key: _pinKey, value: newPin);
      return true;
    }
    return false;
  }

  Future<void> rememberSession(bool remember) async {
    await _storage.write(key: _sessionKey, value: remember.toString());
  }

  Future<bool> isSessionRemembered() async {
    final stored = await _storage.read(key: _sessionKey);
    return stored == 'true';
  }

  Future<void> logout() async {
    await _storage.delete(key: _sessionKey);
  }
}
