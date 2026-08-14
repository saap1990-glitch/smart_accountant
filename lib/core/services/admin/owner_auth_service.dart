import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OwnerAuthService {
  static const _storage = FlutterSecureStorage();
  static const _ownerKey = 'owner_secret';
  static const _defaultSecret = 'smart2026admin';

  Future<bool> verifyOwner(String code) async {
    final stored = await _storage.read(key: _ownerKey) ?? _defaultSecret;
    return code == stored;
  }

  Future<void> changeOwnerSecret(String newSecret) async {
    await _storage.write(key: _ownerKey, value: newSecret);
  }

  Future<bool> isOwnerDevice() async {
    final stored = await _storage.read(key: _ownerKey);
    return stored == _defaultSecret;
  }
}
