import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AntiTamperService {
  final _storage = const FlutterSecureStorage();
  static const _lastKnownTimeKey = 'last_known_time';
  static const _tamperDetectedKey = 'tamper_detected';

  // حفظ آخر وقت معروف
  Future<void> recordTime() async {
    await _storage.write(
      key: _lastKnownTimeKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  // التحقق من التلاعب
  Future<bool> checkTampering() async {
    final lastStr = await _storage.read(key: _lastKnownTimeKey);
    if (lastStr == null) {
      await recordTime();
      return false;
    }

    final lastTime = DateTime.parse(lastStr);
    final now = DateTime.now();

    // إذا رجع الوقت للخلف أكثر من ساعة = تلاعب
    if (now.isBefore(lastTime.subtract(const Duration(hours: 1)))) {
      await _storage.write(key: _tamperDetectedKey, value: 'true');
      return true;
    }

    await recordTime();
    return false;
  }

  Future<bool> wasTampered() async {
    return await _storage.read(key: _tamperDetectedKey) == 'true';
  }

  Future<void> resetTamperFlag() async {
    await _storage.delete(key: _tamperDetectedKey);
  }
}
