import 'package:drift/drift.dart';
import '../database/app_database.dart';

class MasterDataRepository {
  final AppDatabase db;
  MasterDataRepository(this.db);

  // Accounts
  Future<int> insertAccount(Map<String, dynamic> data) {
    return db.into(db.accounts).insert(AccountsCompanion(
      number: Value(data['number']), nameAr: Value(data['name_ar']), nameEn: Value(data['name_en']),
      type: Value(data['type']), nature: Value(data['nature']), parentId: Value(data['parent_id']),
      level: Value(data['level']), acceptsPosting: Value(data['accepts_posting'] ?? false),
    ));
  }
  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    final rows = await db.select(db.accounts).get();
    return rows.map((r) => {'id': r.id, 'number': r.number, 'name_ar': r.nameAr, 'name_en': r.nameEn,
      'type': r.type, 'nature': r.nature, 'parent_id': r.parentId, 'level': r.level}).toList();
  }
  Future<int> updateAccount(int id, Map<String, dynamic> data) async {
    return (db.update(db.accounts)..where((t) => t.id.equals(id))).write(AccountsCompanion(
      nameAr: Value(data['name_ar']), nameEn: Value(data['name_en']), isActive: Value(data['is_active']),
    ));
  }
  Future<int> deleteAccount(int id) async {
    return (db.delete(db.accounts)..where((t) => t.id.equals(id))).go();
  }

  // Customers
  Future<int> insertCustomer(Map<String, dynamic> data) => db.into(db.customers).insert(CustomersCompanion(name: Value(data['name']), phone: Value(data['phone']), address: Value(data['address'])));
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final rows = await db.select(db.customers).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'phone': r.phone, 'address': r.address}).toList();
  }
  Future<int> updateCustomer(int id, Map<String, dynamic> data) async {
    return (db.update(db.customers)..where((t) => t.id.equals(id))).write(CustomersCompanion(name: Value(data['name']), phone: Value(data['phone']), address: Value(data['address'])));
  }
  Future<int> deleteCustomer(int id) async => (db.delete(db.customers)..where((t) => t.id.equals(id))).go();

  // Suppliers
  Future<int> insertSupplier(Map<String, dynamic> data) => db.into(db.suppliers).insert(SuppliersCompanion(name: Value(data['name']), phone: Value(data['phone']), address: Value(data['address'])));
  Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    final rows = await db.select(db.suppliers).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'phone': r.phone, 'address': r.address}).toList();
  }
  Future<int> updateSupplier(int id, Map<String, dynamic> data) async {
    return (db.update(db.suppliers)..where((t) => t.id.equals(id))).write(SuppliersCompanion(name: Value(data['name']), phone: Value(data['phone']), address: Value(data['address'])));
  }
  Future<int> deleteSupplier(int id) async => (db.delete(db.suppliers)..where((t) => t.id.equals(id))).go();

  // Items
  Future<int> insertItem(Map<String, dynamic> data) => db.into(db.items).insert(ItemsCompanion(name: Value(data['name']), unit: Value(data['unit']), cost: Value(data['cost']?.toString() ?? '0'), price: Value(data['price']?.toString() ?? '0')));
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final rows = await db.select(db.items).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'unit': r.unit, 'cost': r.cost, 'price': r.price}).toList();
  }
  Future<int> updateItem(int id, Map<String, dynamic> data) async {
    return (db.update(db.items)..where((t) => t.id.equals(id))).write(ItemsCompanion(name: Value(data['name']), unit: Value(data['unit']), cost: Value(data['cost']?.toString() ?? '0'), price: Value(data['price']?.toString() ?? '0')));
  }
  Future<int> deleteItem(int id) async => (db.delete(db.items)..where((t) => t.id.equals(id))).go();

  // Units
  Future<int> insertUnit(Map<String, dynamic> data) => db.into(db.units).insert(UnitsCompanion(name: Value(data['name']), abbreviation: Value(data['abbreviation'])));
  Future<List<Map<String, dynamic>>> getAllUnits() async {
    final rows = await db.select(db.units).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'abbreviation': r.abbreviation}).toList();
  }
  Future<int> deleteUnit(int id) async => (db.delete(db.units)..where((t) => t.id.equals(id))).go();

  // Warehouses
  Future<int> insertWarehouse(Map<String, dynamic> data) => db.into(db.warehouses).insert(WarehousesCompanion(name: Value(data['name']), location: Value(data['location'])));
  Future<List<Map<String, dynamic>>> getAllWarehouses() async {
    final rows = await db.select(db.warehouses).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'location': r.location}).toList();
  }
  Future<int> deleteWarehouse(int id) async => (db.delete(db.warehouses)..where((t) => t.id.equals(id))).go();

  // Banks
  Future<int> insertBank(Map<String, dynamic> data) => db.into(db.banks).insert(BanksCompanion(name: Value(data['name']), accountNumber: Value(data['account_number'])));
  Future<List<Map<String, dynamic>>> getAllBanks() async {
    final rows = await db.select(db.banks).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'account_number': r.accountNumber}).toList();
  }
  Future<int> deleteBank(int id) async => (db.delete(db.banks)..where((t) => t.id.equals(id))).go();

  // Cash Boxes
  Future<int> insertCashBox(Map<String, dynamic> data) => db.into(db.cashBoxes).insert(CashBoxesCompanion(name: Value(data['name'])));
  Future<List<Map<String, dynamic>>> getAllCashBoxes() async {
    final rows = await db.select(db.cashBoxes).get();
    return rows.map((r) => {'id': r.id, 'name': r.name}).toList();
  }
  Future<int> deleteCashBox(int id) async => (db.delete(db.cashBoxes)..where((t) => t.id.equals(id))).go();

  // Wallets
  Future<int> insertWallet(Map<String, dynamic> data) => db.into(db.wallets).insert(WalletsCompanion(name: Value(data['name']), provider: Value(data['provider'])));
  Future<List<Map<String, dynamic>>> getAllWallets() async {
    final rows = await db.select(db.wallets).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'provider': r.provider}).toList();
  }
  Future<int> deleteWallet(int id) async => (db.delete(db.wallets)..where((t) => t.id.equals(id))).go();

  // Exchange Companies
  Future<int> insertExchangeCompany(Map<String, dynamic> data) => db.into(db.exchangeCompanies).insert(ExchangeCompaniesCompanion(name: Value(data['name']), phone: Value(data['phone'])));
  Future<List<Map<String, dynamic>>> getAllExchangeCompanies() async {
    final rows = await db.select(db.exchangeCompanies).get();
    return rows.map((r) => {'id': r.id, 'name': r.name, 'phone': r.phone}).toList();
  }
  Future<int> deleteExchangeCompany(int id) async => (db.delete(db.exchangeCompanies)..where((t) => t.id.equals(id))).go();

  // Currencies
  Future<int> insertCurrency(Map<String, dynamic> data) => db.into(db.currencies).insert(CurrenciesCompanion(code: Value(data['code']), name: Value(data['name'])));
  Future<List<Map<String, dynamic>>> getAllCurrencies() async {
    final rows = await db.select(db.currencies).get();
    return rows.map((r) => {'id': r.id, 'code': r.code, 'name': r.name}).toList();
  }
  Future<int> deleteCurrency(int id) async => (db.delete(db.currencies)..where((t) => t.id.equals(id))).go();
}
