import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final _storage = const FlutterSecureStorage();

  /// تشفير نص وحفظه
  Future<void> saveSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// قراءة قيمة مشفرة
  Future<String?> readSecure(String key) async {
    return _storage.read(key: key);
  }

  /// حذف قيمة مشفرة
  Future<void> deleteSecure(String key) async {
    await _storage.delete(key: key);
  }
}
