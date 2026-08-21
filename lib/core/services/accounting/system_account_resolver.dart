import 'package:drift/drift.dart';
import '../../database/app_database.dart';

class SystemAccountResolver {
  SystemAccountResolver(this._db);
  final AppDatabase _db;
  final Map<String, int> _cache = {};

  static const Map<String, String> _systemCodes = {
    'cash_default': '1101',
    'bank_default': '1102',
    'exchange_parent': '1103',
    'exchange_default': '1103', // alias
    'wallet_parent': '1104',
    'wallet_default': '1104', // alias
    'customer_parent': '1105',
    'inventory_default': '1106',
    'supplier_parent': '2101',
    'sales_revenue': '4101',
    'sales_default': '4101', // alias
    'cogs': '3107',
    'expense_default': '3102',
    'retained_earnings': '2202',
  };

  Future<int> resolve(String systemCode) async {
    if (_cache.containsKey(systemCode)) {
      return _cache[systemCode]!;
    }
    final accountNumber = _systemCodes[systemCode];
    if (accountNumber == null) {
      throw ArgumentError('رمز النظام غير معروف: $systemCode');
    }
    final account = await (_db.select(
      _db.accounts,
    )..where((t) => t.number.equals(accountNumber))).getSingleOrNull();
    if (account == null) {
      throw StateError('الحساب النظامي غير موجود: $accountNumber');
    }
    _cache[systemCode] = account.id;
    return account.id;
  }

  Future<Map<String, int>> resolveAll(List<String> codes) async {
    final result = <String, int>{};
    for (final code in codes) {
      try {
        result[code] = await resolve(code);
      } catch (e) {
        print('خطأ في حل الرمز $code: $e');
      }
    }
    return result;
  }

  Future<void> ensureAll() async {
    await _ensureSystemAccounts();
  }

  Future<void> _ensureSystemAccounts() async {
    // التأكد من وجود الحسابات الأبوية أولاً
    final parents = {
      '1': {
        'nameAr': 'الأصول',
        'nameEn': 'Assets',
        'type': 'asset',
        'nature': 'debit',
        'level': 1,
      },
      '11': {
        'nameAr': 'الأصول المتداولة',
        'nameEn': 'Current Assets',
        'parent': '1',
        'type': 'asset',
        'nature': 'debit',
        'level': 2,
      },
      '12': {
        'nameAr': 'الأصول غير المتداولة',
        'nameEn': 'Non-current Assets',
        'parent': '1',
        'type': 'asset',
        'nature': 'debit',
        'level': 2,
      },
      '2': {
        'nameAr': 'الخصوم',
        'nameEn': 'Liabilities',
        'type': 'liability',
        'nature': 'credit',
        'level': 1,
      },
      '21': {
        'nameAr': 'الخصوم المتداولة',
        'nameEn': 'Current Liabilities',
        'parent': '2',
        'type': 'liability',
        'nature': 'credit',
        'level': 2,
      },
      '22': {
        'nameAr': 'الخصوم طويلة الأجل',
        'nameEn': 'Long-term Liabilities',
        'parent': '2',
        'type': 'liability',
        'nature': 'credit',
        'level': 2,
      },
      '3': {
        'nameAr': 'المصروفات',
        'nameEn': 'Expenses',
        'type': 'expense',
        'nature': 'debit',
        'level': 1,
      },
      '31': {
        'nameAr': 'المصروفات التشغيلية',
        'nameEn': 'Operating Expenses',
        'parent': '3',
        'type': 'expense',
        'nature': 'debit',
        'level': 2,
      },
      '4': {
        'nameAr': 'الإيرادات',
        'nameEn': 'Revenues',
        'type': 'revenue',
        'nature': 'credit',
        'level': 1,
      },
      '41': {
        'nameAr': 'الإيرادات التشغيلية',
        'nameEn': 'Operating Revenues',
        'parent': '4',
        'type': 'revenue',
        'nature': 'credit',
        'level': 2,
      },
    };
    for (final entry in parents.entries) {
      final number = entry.key;
      final data = entry.value;
      final existing = await (_db.select(
        _db.accounts,
      )..where((t) => t.number.equals(number))).getSingleOrNull();
      if (existing != null) continue;
      int? parentId;
      if (data.containsKey('parent')) {
        final parentNumber = data['parent'] as String;
        final parent = await (_db.select(
          _db.accounts,
        )..where((t) => t.number.equals(parentNumber))).getSingleOrNull();
        parentId = parent?.id;
      }
      await _db
          .into(_db.accounts)
          .insert(
            AccountsCompanion(
              number: Value(number),
              nameAr: Value(data['nameAr'] as String),
              nameEn: Value(data['nameEn'] as String),
              type: Value(data['type'] as String),
              nature: Value(data['nature'] as String),
              parentId: Value(parentId),
              level: Value(data['level'] as int),
              acceptsPosting: Value(number.length == 4),
              isSystem: const Value(true),
              isActive: const Value(true),
            ),
          );
    }

    // الحسابات النظامية التفصيلية
    final accounts = {
      '1101': {
        'nameAr': 'النقدية والصناديق',
        'nameEn': 'Cash and Cash Boxes',
        'parent': '11',
        'type': 'asset',
        'nature': 'debit',
        'level': 3,
      },
      '1102': {
        'nameAr': 'البنوك',
        'nameEn': 'Banks',
        'parent': '11',
        'type': 'asset',
        'nature': 'debit',
        'level': 3,
      },
      '1103': {
        'nameAr': 'شركات الصرافة',
        'nameEn': 'Exchange Companies',
        'parent': '11',
        'type': 'asset',
        'nature': 'debit',
        'level': 3,
      },
      '1104': {
        'nameAr': 'المحافظ الإلكترونية',
        'nameEn': 'E-Wallets',
        'parent': '11',
        'type': 'asset',
        'nature': 'debit',
        'level': 3,
      },
      '1105': {
        'nameAr': 'العملاء',
        'nameEn': 'Customers',
        'parent': '11',
        'type': 'asset',
        'nature': 'debit',
        'level': 3,
      },
      '1106': {
        'nameAr': 'المخزون',
        'nameEn': 'Inventory',
        'parent': '11',
        'type': 'asset',
        'nature': 'debit',
        'level': 3,
      },
      '2101': {
        'nameAr': 'الموردون',
        'nameEn': 'Suppliers',
        'parent': '21',
        'type': 'liability',
        'nature': 'credit',
        'level': 3,
      },
      '3107': {
        'nameAr': 'تكلفة المبيعات',
        'nameEn': 'Cost of Goods Sold',
        'parent': '31',
        'type': 'expense',
        'nature': 'debit',
        'level': 3,
      },
      '4101': {
        'nameAr': 'المبيعات',
        'nameEn': 'Sales Revenue',
        'parent': '41',
        'type': 'revenue',
        'nature': 'credit',
        'level': 3,
      },
      '2202': {
        'nameAr': 'الأرباح المحتجزة',
        'nameEn': 'Retained Earnings',
        'parent': '22',
        'type': 'liability',
        'nature': 'credit',
        'level': 3,
      },
    };
    for (final entry in accounts.entries) {
      final number = entry.key;
      final data = entry.value;
      final existing = await (_db.select(
        _db.accounts,
      )..where((t) => t.number.equals(number))).getSingleOrNull();
      if (existing != null) continue;
      final parentNumber = data['parent'] as String;
      final parent = await (_db.select(
        _db.accounts,
      )..where((t) => t.number.equals(parentNumber))).getSingleOrNull();
      if (parent == null) continue;
      await _db
          .into(_db.accounts)
          .insert(
            AccountsCompanion(
              number: Value(number),
              nameAr: Value(data['nameAr'] as String),
              nameEn: Value(data['nameEn'] as String),
              type: Value(data['type'] as String),
              nature: Value(data['nature'] as String),
              parentId: Value(parent.id),
              level: Value(data['level'] as int),
              acceptsPosting: const Value(true),
              isSystem: const Value(true),
              isActive: const Value(true),
            ),
          );
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
