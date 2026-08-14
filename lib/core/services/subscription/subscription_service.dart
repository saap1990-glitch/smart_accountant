import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SubscriptionType { trial, semiAnnual, annual, lifetime }

class SubscriptionService {
  final _storage = const FlutterSecureStorage();
  static const _startKey = 'subscription_start';
  static const _typeKey = 'subscription_type';
  static const _activationCodeKey = 'activation_code';

  SubscriptionType _type = SubscriptionType.trial;
  DateTime? _startDate;
  String? _activationCode;

  SubscriptionService() {
    _load();
  }

  Future<void> _load() async {
    final startStr = await _storage.read(key: _startKey);
    if (startStr != null) {
      _startDate = DateTime.parse(startStr);
    } else {
      _startDate = DateTime.now();
      await _storage.write(key: _startKey, value: _startDate!.toIso8601String());
    }

    final typeStr = await _storage.read(key: _typeKey);
    if (typeStr != null) {
      _type = SubscriptionType.values.firstWhere((e) => e.name == typeStr, orElse: () => SubscriptionType.trial);
    }

    _activationCode = await _storage.read(key: _activationCodeKey);
  }

  Future<void> _save() async {
    if (_startDate != null) {
      await _storage.write(key: _startKey, value: _startDate!.toIso8601String());
    }
    await _storage.write(key: _typeKey, value: _type.name);
  }

  SubscriptionType get type => _type;
  String? get activationCode => _activationCode;

  int get totalDays {
    switch (_type) {
      case SubscriptionType.trial: return 90;
      case SubscriptionType.semiAnnual: return 180;
      case SubscriptionType.annual: return 365;
      case SubscriptionType.lifetime: return 36500; // 100 سنة
    }
  }

  DateTime? get expiryDate {
    if (_startDate == null) return null;
    return _startDate!.add(Duration(days: totalDays));
  }

  bool get isActive {
    if (_type == SubscriptionType.lifetime) return true;
    if (expiryDate == null) return false;
    return DateTime.now().isBefore(expiryDate!);
  }

  int get daysLeft {
    if (!isActive) return 0;
    if (expiryDate == null) return 0;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  int get daysUsed {
    if (_startDate == null) return 0;
    return DateTime.now().difference(_startDate!).inDays;
  }

  double get usagePercentage {
    if (totalDays == 0) return 100;
    return (daysUsed / totalDays * 100).clamp(0, 100);
  }

  bool get shouldWarn {
    return isActive && daysLeft <= 7 && _type != SubscriptionType.lifetime;
  }

  String get warningMessage {
    if (!shouldWarn) return '';
    if (daysLeft <= 1) return '⏰ تنبيه: اشتراكك سينتهي غداً! قم بالتجديد الآن.';
    if (daysLeft <= 7) return '⚠️ تنبيه: متبقي $daysLeft أيام على انتهاء الاشتراك.';
    return '';
  }

  // تفعيل برمز
  Future<bool> activate(String code) async {
    // يمكن ربطه بخادم خارجي للتحقق
    if (code.length < 6) return false;

    if (code.startsWith('SEMI')) {
      _type = SubscriptionType.semiAnnual;
    } else if (code.startsWith('ANNUAL')) {
      _type = SubscriptionType.annual;
    } else if (code.startsWith('LIFE')) {
      _type = SubscriptionType.lifetime;
    } else {
      return false;
    }

    _startDate = DateTime.now();
    _activationCode = code;
    await _storage.write(key: _activationCodeKey, value: code);
    await _save();
    return true;
  }

  // توليد رمز (للمالك فقط)
  static String generateCode(SubscriptionType type, String secret) {
    final prefix = type == SubscriptionType.semiAnnual ? 'SEMI' : type == SubscriptionType.annual ? 'ANNUAL' : 'LIFE';
    final hash = (secret + DateTime.now().millisecondsSinceEpoch.toString()).hashCode.abs().toString().padLeft(6, '0');
    return '$prefix-${hash.substring(0, 8)}';
  }
}
