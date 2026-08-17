import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class AccountingLinkService {
  final AppDatabase _db;

  AccountingLinkService(this._db);

  Future<int> createAndLink({
    required String module,
    required String entityType,
    required String entityId,
    required String entityName,
    required String parentSystemCode,
  }) async {
    return createLink(
      module: module,
      entityType: entityType,
      entityId: entityId,
      entityName: entityName,
      parentSystemCode: parentSystemCode,
    );
  }

  Future<int> createLink({
    required String module,
    required String entityType,
    required String entityId,
    required String entityName,
    required String parentSystemCode,
  }) async {
    final existing = await getLinkedAccount(module, entityType, entityId);

    if (existing != null) {
      return existing;
    }

    final parentId = await _ensureParentExists(parentSystemCode);

    final parent = await (_db.select(
      _db.accounts,
    )..where((t) => t.id.equals(parentId))).getSingle();

    final parentLevel = parent.level;

    if (parentLevel >= 5) {
      throw StateError('لا يمكن إنشاء حساب فرعي تحت المستوى الخامس');
    }

    final children = await (_db.select(
      _db.accounts,
    )..where((t) => t.parentId.equals(parentId))).get();

    var nextSequence = 1;

    for (final child in children) {
      final number = child.number;

      if (number.startsWith(parent.number) &&
          number.length == parent.number.length + 2) {
        final suffix = int.tryParse(number.substring(parent.number.length));

        if (suffix != null && suffix >= nextSequence) {
          nextSequence = suffix + 1;
        }
      }
    }

    if (nextSequence > 99) {
      throw StateError('تم الوصول إلى الحد الأقصى للحسابات الفرعية');
    }

    final nextNumber =
        '${parent.number}${nextSequence.toString().padLeft(2, '0')}';

    final accountId = await _db
        .into(_db.accounts)
        .insert(
          AccountsCompanion(
            number: Value(nextNumber),
            nameAr: Value(entityName),
            nameEn: Value(entityName),
            type: Value(parent.type),
            nature: Value(parent.nature),
            parentId: Value(parentId),
            level: Value(parentLevel + 1),
            acceptsPosting: Value(parentLevel + 1 == 5),
            isSystem: const Value(false),
            isActive: const Value(true),
          ),
        );

    await _db
        .into(_db.accountLinks)
        .insert(
          AccountLinksCompanion(
            module: Value(module),
            entityType: Value(entityType),
            entityId: Value(entityId),
            accountId: Value(accountId),
          ),
        );

    return accountId;
  }

  Future<int> _ensureParentExists(String systemCode) async {
    String number;

    switch (systemCode) {
      case 'customer_parent':
        number = '1105';
        break;

      case 'supplier_parent':
        number = '2101';
        break;

      case 'bank_default':
        number = '1102';
        break;

      case 'cash_default':
        number = '1101';
        break;

      case 'wallet_parent':
        number = '1104';
        break;

      case 'exchange_parent':
        number = '1103';
        break;

      case 'inventory_default':
        number = '1106';
        break;

      case 'sales_default':
        number = '4101';
        break;

      case 'expense_default':
        number = '3102';
        break;

      default:
        throw ArgumentError('رمز الحساب النظامي غير معروف: $systemCode');
    }

    return _getByNumber(number);
  }

  Future<int> _getByNumber(String number) async {
    final account = await (_db.select(
      _db.accounts,
    )..where((t) => t.number.equals(number))).getSingleOrNull();

    if (account == null) {
      throw StateError(
        'الحساب النظامي $number غير موجود. '
        'يجب تشغيل تهيئة دليل الحسابات أولًا.',
      );
    }

    return account.id;
  }

  Future<int?> getLinkedAccount(
    String module,
    String entityType,
    String entityId,
  ) async {
    final link =
        await (_db.select(_db.accountLinks)
              ..where((t) => t.module.equals(module))
              ..where((t) => t.entityType.equals(entityType))
              ..where((t) => t.entityId.equals(entityId)))
            .getSingleOrNull();

    return link?.accountId;
  }

  Future<void> seedDefaultAccounts() async {
    final a1 = await _ensureAccount(
      number: '1',
      nameAr: 'الأصول',
      nameEn: 'Assets',
      type: 'asset',
      nature: 'debit',
      parentId: null,
      level: 1,
    );
    final a2 = await _ensureAccount(
      number: '2',
      nameAr: 'الخصوم',
      nameEn: 'Liabilities',
      type: 'liability',
      nature: 'credit',
      parentId: null,
      level: 1,
    );
    final a3 = await _ensureAccount(
      number: '3',
      nameAr: 'المصروفات',
      nameEn: 'Expenses',
      type: 'expense',
      nature: 'debit',
      parentId: null,
      level: 1,
    );
    final a4 = await _ensureAccount(
      number: '4',
      nameAr: 'الإيرادات',
      nameEn: 'Revenues',
      type: 'revenue',
      nature: 'credit',
      parentId: null,
      level: 1,
    );

    final a11 = await _ensureAccount(
      number: '11',
      nameAr: 'الأصول المتداولة',
      nameEn: 'Current Assets',
      type: 'asset',
      nature: 'debit',
      parentId: a1,
      level: 2,
    );
    final a12 = await _ensureAccount(
      number: '12',
      nameAr: 'الأصول غير المتداولة',
      nameEn: 'Non-current Assets',
      type: 'asset',
      nature: 'debit',
      parentId: a1,
      level: 2,
    );
    final a21 = await _ensureAccount(
      number: '21',
      nameAr: 'الخصوم المتداولة',
      nameEn: 'Current Liabilities',
      type: 'liability',
      nature: 'credit',
      parentId: a2,
      level: 2,
    );
    final a22 = await _ensureAccount(
      number: '22',
      nameAr: 'الخصوم طويلة الأجل',
      nameEn: 'Long-term Liabilities',
      type: 'liability',
      nature: 'credit',
      parentId: a2,
      level: 2,
    );
    final a31 = await _ensureAccount(
      number: '31',
      nameAr: 'المصروفات التشغيلية',
      nameEn: 'Operating Expenses',
      type: 'expense',
      nature: 'debit',
      parentId: a3,
      level: 2,
    );
    final a41 = await _ensureAccount(
      number: '41',
      nameAr: 'الإيرادات التشغيلية',
      nameEn: 'Operating Revenues',
      type: 'revenue',
      nature: 'credit',
      parentId: a4,
      level: 2,
    );

    await _default3(
      '1101',
      'النقدية والصناديق',
      'Cash and Cash Boxes',
      a11,
      'asset',
      'debit',
    );
    await _default3('1102', 'البنوك', 'Banks', a11, 'asset', 'debit');
    await _default3(
      '1103',
      'شركات الصرافة',
      'Exchange Companies',
      a11,
      'asset',
      'debit',
    );
    await _default3(
      '1104',
      'المحافظ الإلكترونية',
      'E-Wallets',
      a11,
      'asset',
      'debit',
    );
    await _default3('1105', 'العملاء', 'Customers', a11, 'asset', 'debit');
    await _default3('1106', 'المخزون', 'Inventory', a11, 'asset', 'debit');
    await _default3('1201', 'الأراضي', 'Land', a12, 'asset', 'debit');
    await _default3('1202', 'المباني', 'Buildings', a12, 'asset', 'debit');
    await _default3('1203', 'السيارات', 'Vehicles', a12, 'asset', 'debit');
    await _default3(
      '1204',
      'الأثاث والمعدات',
      'Furniture and Equipment',
      a12,
      'asset',
      'debit',
    );

    await _default3(
      '2101',
      'الموردون',
      'Suppliers',
      a21,
      'liability',
      'credit',
    );
    await _default3(
      '2102',
      'أوراق الدفع',
      'Notes Payable',
      a21,
      'liability',
      'credit',
    );
    await _default3(
      '2103',
      'مصروفات مستحقة',
      'Accrued Expenses',
      a21,
      'liability',
      'credit',
    );
    await _default3(
      '2201',
      'القروض طويلة الأجل',
      'Long-term Loans',
      a22,
      'liability',
      'credit',
    );

    await _default3(
      '3101',
      'الرواتب والأجور',
      'Salaries and Wages',
      a31,
      'expense',
      'debit',
    );
    await _default3('3102', 'الإيجارات', 'Rent', a31, 'expense', 'debit');
    await _default3(
      '3103',
      'الكهرباء والمياه',
      'Utilities',
      a31,
      'expense',
      'debit',
    );
    await _default3(
      '3104',
      'النقل والمواصلات',
      'Transport',
      a31,
      'expense',
      'debit',
    );
    await _default3(
      '3105',
      'الاتصالات',
      'Communication',
      a31,
      'expense',
      'debit',
    );
    await _default3('3106', 'الإهلاك', 'Depreciation', a31, 'expense', 'debit');

    await _default3('4101', 'المبيعات', 'Sales', a41, 'revenue', 'credit');
    await _default3(
      '4102',
      'إيرادات الخدمات',
      'Service Revenue',
      a41,
      'revenue',
      'credit',
    );
    await _default3(
      '4103',
      'إيرادات أخرى',
      'Other Revenue',
      a41,
      'revenue',
      'credit',
    );
  }

  Future<void> _default3(
    String n,
    String ar,
    String en,
    int p,
    String t,
    String r,
  ) async {
    await _ensureAccount(
      number: n,
      nameAr: ar,
      nameEn: en,
      type: t,
      nature: r,
      parentId: p,
      level: 3,
    );
  }

  Future<void> _default45(
    int p,
    String n,
    String ar,
    String en,
    String t,
    String r,
  ) async {
    final l4 = await _ensureAccount(
      number: n,
      nameAr: ar,
      nameEn: en,
      type: t,
      nature: r,
      parentId: p,
      level: 4,
    );
    await _ensureAccount(
      number: '${n}01',
      nameAr: '${ar} - رئيسي',
      nameEn: '${en} - Main',
      type: t,
      nature: r,
      parentId: l4,
      level: 5,
    );
  }

  Future<int> _ensureAccount({
    required String number,
    required String nameAr,
    required String nameEn,
    required String type,
    required String nature,
    required int? parentId,
    required int level,
    bool acceptsPosting = false,
  }) async {
    final existing = await (_db.select(
      _db.accounts,
    )..where((t) => t.number.equals(number))).getSingleOrNull();

    if (existing != null) {
      return existing.id;
    }

    return _db
        .into(_db.accounts)
        .insert(
          AccountsCompanion(
            number: Value(number),
            nameAr: Value(nameAr),
            nameEn: Value(nameEn),
            type: Value(type),
            nature: Value(nature),
            parentId: Value(parentId),
            level: Value(level),
            acceptsPosting: Value(level == 5 && acceptsPosting),
            isSystem: const Value(true),
            isActive: const Value(true),
          ),
        );
  }
}
