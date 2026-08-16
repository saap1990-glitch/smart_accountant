import 'package:drift/drift.dart';
import '../../database/app_database.dart';
import '../numbering/number_generator.dart';

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
    final parentId = await _ensureParentExists(parentSystemCode);
    final parent = await (_db.select(_db.accounts)..where((t) => t.id.equals(parentId))).getSingle();
    final children = await (_db.select(_db.accounts)..where((t) => t.parentId.equals(parentId))).get();
    final nextNumber = '${parent.number}${(children.length + 1).toString().padLeft(2, '0')}';

    final accountId = await _db.into(_db.accounts).insert(AccountsCompanion(
      number: Value(nextNumber), nameAr: Value(entityName), nameEn: Value(entityName),
      type: Value(parent.type), nature: Value(parent.nature), parentId: Value(parentId),
      level: Value(parent.level + 1), acceptsPosting: const Value(true),
      isSystem: const Value(false), isActive: const Value(true),
    ));

    await _db.into(_db.accountLinks).insert(AccountLinksCompanion(
      module: Value(module), entityType: Value(entityType), entityId: Value(entityId), accountId: Value(accountId),
    ));
    return accountId;
  }

  Future<int> _ensureParentExists(String systemCode) async {
    switch (systemCode) {
      case 'customer_parent': return _getOrCreate('1105', 'العملاء', 'Customers', 'asset', 'debit', 11, 3);
      case 'supplier_parent': return _getOrCreate('2101', 'الموردون', 'Suppliers', 'liability', 'credit', 21, 3);
      case 'bank_default': return _getOrCreate('1102', 'البنوك', 'Banks', 'asset', 'debit', 11, 3);
      case 'cash_default': return _getOrCreate('1101', 'الصندوق', 'Cash', 'asset', 'debit', 11, 3);
      case 'wallet_parent': return _getOrCreate('1104', 'المحافظ الإلكترونية', 'E-Wallets', 'asset', 'debit', 11, 3);
      case 'exchange_parent': return _getOrCreate('1103', 'شركات الصرافة', 'Exchange', 'asset', 'debit', 11, 3);
      case 'inventory_default': return _getOrCreate('1106', 'المخزون', 'Inventory', 'asset', 'debit', 11, 3);
      case 'sales_default': return _getOrCreate('4101', 'المبيعات', 'Sales', 'revenue', 'credit', 41, 3);
      case 'expense_default': return _getOrCreate('3101', 'المصروفات التشغيلية', 'Expenses', 'expense', 'debit', 31, 3);
      case 'cogs_default': return _getOrCreate('3102', 'تكلفة المبيعات', 'Cost of Goods Sold', 'expense', 'debit', 31, 3);
      default: return _getOrCreate('1101', 'افتراضي', 'Default', 'asset', 'debit', 11, 3);
    }
  }

  Future<int> _getOrCreate(String number, String nameAr, String nameEn, String type, String nature, int parentNumber, int level) async {
    final existing = await (_db.select(_db.accounts)..where((t) => t.number.equals(number))).getSingleOrNull();
    if (existing != null) return existing.id;
    return _db.into(_db.accounts).insert(AccountsCompanion(
      number: Value(number), nameAr: Value(nameAr), nameEn: Value(nameEn),
      type: Value(type), nature: Value(nature), parentId: const Value(null),
      level: Value(level), acceptsPosting: const Value(true),
      isSystem: const Value(true), isActive: const Value(true),
    ));
  }

  Future<int?> getLinkedAccount(String module, String entityType, String entityId) async {
    final link = await (_db.select(_db.accountLinks)
      ..where((t) => t.module.equals(module))
      ..where((t) => t.entityType.equals(entityType))
      ..where((t) => t.entityId.equals(entityId))).getSingleOrNull();
    return link?.accountId;
  }

  Future<void> seedDefaultAccounts() async {
    final count = await _db.select(_db.accounts).get().then((v) => v.length);
    if (count > 0) return;

    // المستوى 1
    final a1 = await _insert('1', 'الأصول', 'Assets', 'asset', 'debit', null, 1);
    final a2 = await _insert('2', 'الخصوم', 'Liabilities', 'liability', 'credit', null, 1);
    final a3 = await _insert('3', 'المصروفات', 'Expenses', 'expense', 'debit', null, 1);
    final a4 = await _insert('4', 'الإيرادات', 'Revenues', 'revenue', 'credit', null, 1);

    // المستوى 2
    final a11 = await _insert('11', 'الأصول المتداولة', 'Current Assets', 'asset', 'debit', a1, 2);
    final a12 = await _insert('12', 'الأصول غير المتداولة', 'Fixed Assets', 'asset', 'debit', a1, 2);
    final a21 = await _insert('21', 'الخصوم المتداولة', 'Current Liabilities', 'liability', 'credit', a2, 2);
    final a22 = await _insert('22', 'الخصوم طويلة الأجل', 'Long-term Liabilities', 'liability', 'credit', a2, 2);
    final a31 = await _insert('31', 'المصروفات التشغيلية', 'Operating Expenses', 'expense', 'debit', a3, 2);
    final a41 = await _insert('41', 'إيرادات النشاط الرئيسي', 'Main Revenues', 'revenue', 'credit', a4, 2);

    // المستوى 3
    await _insert('1101', 'الصندوق', 'Cash', 'asset', 'debit', a11, 3);
    await _insert('1102', 'البنوك', 'Banks', 'asset', 'debit', a11, 3);
    await _insert('1103', 'شركات الصرافة', 'Exchange Companies', 'asset', 'debit', a11, 3);
    await _insert('1104', 'المحافظ الإلكترونية', 'E-Wallets', 'asset', 'debit', a11, 3);
    await _insert('1105', 'العملاء', 'Customers', 'asset', 'debit', a11, 3);
    await _insert('1106', 'المخزون', 'Inventory', 'asset', 'debit', a11, 3);
    await _insert('1201', 'الأراضي', 'Lands', 'asset', 'debit', a12, 3);
    await _insert('1202', 'المباني', 'Buildings', 'asset', 'debit', a12, 3);
    await _insert('2101', 'الموردون', 'Suppliers', 'liability', 'credit', a21, 3);
    await _insert('2102', 'أوراق الدفع', 'Notes Payable', 'liability', 'credit', a21, 3);
    await _insert('2201', 'القروض', 'Loans', 'liability', 'credit', a22, 3);
    await _insert('3101', 'الرواتب', 'Salaries', 'expense', 'debit', a31, 3);
    await _insert('3102', 'الإيجارات', 'Rent', 'expense', 'debit', a31, 3);
    await _insert('3103', 'الكهرباء', 'Electricity', 'expense', 'debit', a31, 3);
    await _insert('4101', 'المبيعات', 'Sales', 'revenue', 'credit', a41, 3);

    // المستوى 4 (أمثلة)
    final cashId = await _getByNumber('1101');
    final bankId = await _getByNumber('1102');
    await _insert('110101', 'الصندوق الرئيسي', 'Main Cash', 'asset', 'debit', cashId, 4);
    await _insert('110102', 'صندوق الفرع', 'Branch Cash', 'asset', 'debit', cashId, 4);
    await _insert('110201', 'حساب جاري', 'Current Account', 'asset', 'debit', bankId, 4);

    // المستوى 5 (مثال)
    final mainCashId = await _getByNumber('110101');
    await _insert('11010101', 'صندوق الخزنة', 'Safe Box', 'asset', 'debit', mainCashId, 5);
  }

  Future<int> _insert(String number, String nameAr, String nameEn, String type, String nature, int? parentId, int level) async {
    return _db.into(_db.accounts).insert(AccountsCompanion(
      number: Value(number), nameAr: Value(nameAr), nameEn: Value(nameEn),
      type: Value(type), nature: Value(nature), parentId: Value(parentId),
      level: Value(level), acceptsPosting: Value(level >= 4),
      isSystem: const Value(true), isActive: const Value(true),
    ));
  }

  Future<int> _getByNumber(String number) async {
    final acc = await (_db.select(_db.accounts)..where((t) => t.number.equals(number))).getSingle();
    return acc.id;
  }
}
