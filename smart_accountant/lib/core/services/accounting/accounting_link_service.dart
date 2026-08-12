import 'package:drift/drift.dart';
import '../../database/app_database.dart';
import '../../database/tables/account_links_table.dart';
import '../../database/tables/system_accounts_table.dart';
import '../../database/tables/accounts_table.dart';
import '../numbering/number_generator.dart';
import '../../errors/app_exception.dart';

class AccountingLinkService {
  final AppDatabase _db;
  final NumberGenerator _numberGenerator;

  AccountingLinkService(this._db, this._numberGenerator);

  Future<int> createAndLink({
    required String module,
    required String entityType,
    required String entityId,
    required String entityName,
    required String parentSystemCode,
  }) async {
    final parentAccount = await (_db.select(_db.systemAccounts)
      ..where((t) => t.systemCode.equals(parentSystemCode))
      ..where((t) => t.isActive.equals(true))).getSingleOrNull();

    if (parentAccount == null) {
      throw AppException('الحساب الأب غير موجود: $parentSystemCode');
    }

    final parent = await (_db.select(_db.accounts)
      ..where((t) => t.id.equals(parentAccount.accountId))).getSingleOrNull();

    if (parent == null) {
      throw AppException('الحساب الأب غير موجود في شجرة الحسابات');
    }

    final existingChildren = await (_db.select(_db.accounts)
      ..where((t) => t.parentId.equals(parent.id))).get();
    final nextNumber = _generateNextNumber(parent.number, existingChildren.length + 1);

    final accountId = await _db.into(_db.accounts).insert(AccountsCompanion(
      number: Value(nextNumber),
      nameAr: Value(entityName),
      nameEn: Value(entityName),
      type: Value(parent.type),
      nature: Value(parent.nature),
      parentId: Value(parent.id),
      level: Value(parent.level + 1),
      acceptsPosting: const Value(true),
      isSystem: const Value(false),
      isActive: const Value(true),
    ));

    await _db.into(_db.accountLinks).insert(AccountLinksCompanion(
      module: Value(module),
      entityType: Value(entityType),
      entityId: Value(entityId),
      accountId: Value(accountId),
    ));

    return accountId;
  }

  Future<int?> getLinkedAccount(String module, String entityType, String entityId) async {
    final link = await (_db.select(_db.accountLinks)
      ..where((t) => t.module.equals(module))
      ..where((t) => t.entityType.equals(entityType))
      ..where((t) => t.entityId.equals(entityId))).getSingleOrNull();
    return link?.accountId;
  }

  Future<int> getSystemAccount(String systemCode) async {
    final sysAcc = await (_db.select(_db.systemAccounts)
      ..where((t) => t.systemCode.equals(systemCode))
      ..where((t) => t.isActive.equals(true))).getSingleOrNull();
    if (sysAcc == null) {
      throw AppException('الحساب الافتراضي غير موجود: $systemCode');
    }
    return sysAcc.accountId;
  }

  Future<void> seedDefaultAccounts() async {
    final count = await _db.select(_db.accounts).get().then((v) => v.length);
    if (count > 0) return;

    final assets = await _insert('1', 'الأصول', 'Assets', 'asset', 'debit', null, 1);
    final liabilities = await _insert('2', 'الخصوم', 'Liabilities', 'liability', 'credit', null, 1);
    final expenses = await _insert('3', 'المصروفات', 'Expenses', 'expense', 'debit', null, 1);
    final revenues = await _insert('4', 'الإيرادات', 'Revenues', 'revenue', 'credit', null, 1);

    final currentAssets = await _insert('11', 'الأصول المتداولة', 'Current Assets', 'asset', 'debit', assets, 2);
    await _insert('12', 'الأصول غير المتداولة', 'Fixed Assets', 'asset', 'debit', assets, 2);
    final currentLiabilities = await _insert('21', 'الخصوم المتداولة', 'Current Liabilities', 'liability', 'credit', liabilities, 2);
    await _insert('22', 'الخصوم طويلة الأجل', 'Long-term Liabilities', 'liability', 'credit', liabilities, 2);
    final opExpenses = await _insert('31', 'المصروفات التشغيلية', 'Operating Expenses', 'expense', 'debit', expenses, 2);
    await _insert('32', 'المصروفات الإدارية', 'Admin Expenses', 'expense', 'debit', expenses, 2);
    await _insert('33', 'المصروفات البيعية والتسويقية', 'Sales & Marketing', 'expense', 'debit', expenses, 2);
    await _insert('34', 'المصروفات التمويلية', 'Finance Expenses', 'expense', 'debit', expenses, 2);
    await _insert('35', 'المصروفات الأخرى', 'Other Expenses', 'expense', 'debit', expenses, 2);
    final mainRevenues = await _insert('41', 'إيرادات النشاط الرئيسي', 'Main Revenues', 'revenue', 'credit', revenues, 2);
    await _insert('42', 'الإيرادات الأخرى', 'Other Revenues', 'revenue', 'credit', revenues, 2);

    final cashParent = await _insert('1101', 'الصندوق', 'Cash', 'asset', 'debit', currentAssets, 3);
    final banksParent = await _insert('1102', 'البنوك', 'Banks', 'asset', 'debit', currentAssets, 3);
    final exchangeParent = await _insert('1103', 'شركات الصرافة', 'Exchange Companies', 'asset', 'debit', currentAssets, 3);
    final walletsParent = await _insert('1104', 'المحافظ الإلكترونية', 'E-Wallets', 'asset', 'debit', currentAssets, 3);
    final customersParent = await _insert('1105', 'العملاء', 'Customers', 'asset', 'debit', currentAssets, 3);
    final inventoryParent = await _insert('1106', 'المخزون', 'Inventory', 'asset', 'debit', currentAssets, 3);
    final suppliersParent = await _insert('2101', 'الموردون', 'Suppliers', 'liability', 'credit', currentLiabilities, 3);

    await _insertSys('cash_default', cashParent, 'الحساب الافتراضي للصندوق');
    await _insertSys('bank_default', banksParent, 'الحساب الافتراضي للبنك');
    await _insertSys('exchange_parent', exchangeParent, 'الحساب الأب لشركات الصرافة');
    await _insertSys('wallet_parent', walletsParent, 'الحساب الأب للمحافظ الإلكترونية');
    await _insertSys('customer_parent', customersParent, 'الحساب الأب للعملاء');
    await _insertSys('supplier_parent', suppliersParent, 'الحساب الأب للموردين');
    await _insertSys('inventory_default', inventoryParent, 'الحساب الافتراضي للمخزون');
    await _insertSys('sales_default', mainRevenues, 'الحساب الافتراضي للمبيعات');
    await _insertSys('expense_default', opExpenses, 'الحساب الافتراضي للمصروفات');
  }

  Future<int> _insert(String number, String nameAr, String nameEn, String type, String nature, int? parentId, int level) async {
    return _db.into(_db.accounts).insert(AccountsCompanion(
      number: Value(number),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      type: Value(type),
      nature: Value(nature),
      parentId: Value(parentId),
      level: Value(level),
      acceptsPosting: const Value(false),
      isSystem: const Value(true),
      isActive: const Value(true),
    ));
  }

  Future<void> _insertSys(String code, int accountId, String desc) async {
    await _db.into(_db.systemAccounts).insert(SystemAccountsCompanion(
      systemCode: Value(code),
      accountId: Value(accountId),
      description: Value(desc),
      isActive: const Value(true),
    ));
  }

  String _generateNextNumber(String parentNumber, int childIndex) {
    return '${parentNumber}${childIndex.toString().padLeft(2, '0')}';
  }
}
