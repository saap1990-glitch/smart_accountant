import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SubscriptionType { trial, semiAnnual, annual, lifetime }

class SubscriptionService {
  SubscriptionService() {
    _load();
  }

  final _storage = const FlutterSecureStorage();
  static const _baseUrl = 'https://your-server-url.com'; // ← ضع رابط الخادم هنا
  static const _startKey = 'subscription_start';
  static const _typeKey = 'subscription_type';
  static const _activationCodeKey = 'activation_code';

  final _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  SubscriptionType _type = SubscriptionType.trial;
  DateTime? _startDate;
  String? _activationCode;
  List<String> _generatedCodes = [];
  Set<String> _revokedCodes = {};

  Future<void> _load() async {
    final startStr = await _storage.read(key: _startKey);
    if (startStr != null) {
      _startDate = DateTime.parse(startStr);
    } else {
      _startDate = DateTime.now();
      await _storage.write(
        key: _startKey,
        value: _startDate!.toIso8601String(),
      );
    }

    final typeStr = await _storage.read(key: _typeKey);
    if (typeStr != null) {
      _type = SubscriptionType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => SubscriptionType.trial,
      );
    }

    _activationCode = await _storage.read(key: _activationCodeKey);
  }

  Future<void> _save() async {
    if (_startDate != null) {
      await _storage.write(
        key: _startKey,
        value: _startDate!.toIso8601String(),
      );
    }
    await _storage.write(key: _typeKey, value: _type.name);
    if (_activationCode != null) {
      await _storage.write(key: _activationCodeKey, value: _activationCode);
    }
  }

  // ========== الاتصال بالخادم ==========
  Future<bool> activate(String code) async {
    try {
      final response = await _dio.post('/api/activate', data: {'code': code});
      if (response.data['success'] == true) {
        final typeStr = response.data['type'] as String;
        _type = _parseType(typeStr);
        _startDate = DateTime.parse(response.data['start_date']);
        _activationCode = code;
        await _save();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyRemote() async {
    if (_activationCode == null) return false;
    try {
      final response = await _dio.post(
        '/api/verify',
        data: {'code': _activationCode},
      );
      return response.data['is_active'] == true;
    } catch (e) {
      return false;
    }
  }

  SubscriptionType _parseType(String type) {
    switch (type) {
      case 'semi_annual':
        return SubscriptionType.semiAnnual;
      case 'annual':
        return SubscriptionType.annual;
      case 'lifetime':
        return SubscriptionType.lifetime;
      default:
        return SubscriptionType.trial;
    }
  }

  // ========== الخصائص الحالية (كما السابق) ==========
  SubscriptionType get type => _type;
  String? get activationCode => _activationCode;

  int get totalDays {
    switch (_type) {
      case SubscriptionType.trial:
        return 90;
      case SubscriptionType.semiAnnual:
        return 180;
      case SubscriptionType.annual:
        return 365;
      case SubscriptionType.lifetime:
        return 36500;
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
    if (daysLeft <= 7)
      return '⚠️ تنبيه: متبقي $daysLeft أيام على انتهاء الاشتراك.';
    return '';
  }

  // ========== دوال إدارة الرموز المحلية (للاستخدام في لوحة التحكم) ==========

  Future<String> generateCode(SubscriptionType type) async {
    final prefix = type == SubscriptionType.semiAnnual
        ? 'SEMI'
        : type == SubscriptionType.annual
        ? 'ANNUAL'
        : 'LIFE';
    final code =
        '$prefix-${DateTime.now().millisecondsSinceEpoch.hashCode.abs().toString().substring(0, 8)}';
    _generatedCodes.add(code);
    await _saveCodes();
    return code;
  }

  Future<List<String>> getGeneratedCodes() async =>
      List.unmodifiable(_generatedCodes);

  Future<void> revokeCode(String code) async {
    _revokedCodes.add(code);
    await _saveCodes();
  }

  Future<bool> isCodeRevoked(String code) async => _revokedCodes.contains(code);

  Future<void> _saveCodes() async {
    await _storage.write(
      key: 'generated_codes',
      value: jsonEncode(_generatedCodes),
    );
    await _storage.write(
      key: 'revoked_codes',
      value: jsonEncode(_revokedCodes.toList()),
    );
  }
}
