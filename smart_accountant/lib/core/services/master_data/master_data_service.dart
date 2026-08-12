import '../../repositories/master_data_repository.dart';
import '../accounting/accounting_link_service.dart';

class MasterDataService {
  final MasterDataRepository _repository;
  final AccountingLinkService _linkService;

  MasterDataService(this._repository, this._linkService);

  // Customers
  Future<int> createCustomer({required String name, String? phone, String? address}) async {
    final customerId = await _repository.insertCustomer({'name': name, 'phone': phone, 'address': address});
    await _linkService.createAndLink(module: 'customers', entityType: 'Customer', entityId: customerId.toString(), entityName: name, parentSystemCode: 'customer_parent');
    return customerId;
  }
  Future<List<Map<String, dynamic>>> getAllCustomers() async => _repository.getAllCustomers();
  Future<int> updateCustomer(int id, {required String name, String? phone, String? address}) async =>
      _repository.updateCustomer(id, {'name': name, 'phone': phone, 'address': address});
  Future<int> deleteCustomer(int id) async => _repository.deleteCustomer(id);

  // Suppliers
  Future<int> createSupplier({required String name, String? phone, String? address}) async {
    final supplierId = await _repository.insertSupplier({'name': name, 'phone': phone, 'address': address});
    await _linkService.createAndLink(module: 'suppliers', entityType: 'Supplier', entityId: supplierId.toString(), entityName: name, parentSystemCode: 'supplier_parent');
    return supplierId;
  }
  Future<List<Map<String, dynamic>>> getAllSuppliers() async => _repository.getAllSuppliers();
  Future<int> updateSupplier(int id, {required String name, String? phone, String? address}) async =>
      _repository.updateSupplier(id, {'name': name, 'phone': phone, 'address': address});
  Future<int> deleteSupplier(int id) async => _repository.deleteSupplier(id);

  // Items
  Future<int> createItem({required String name, required String unit, double? cost, double? price}) async =>
      _repository.insertItem({'name': name, 'unit': unit, 'cost': cost, 'price': price});
  Future<List<Map<String, dynamic>>> getAllItems() async => _repository.getAllItems();
  Future<int> updateItem(int id, {required String name, required String unit, double? cost, double? price}) async =>
      _repository.updateItem(id, {'name': name, 'unit': unit, 'cost': cost, 'price': price});
  Future<int> deleteItem(int id) async => _repository.deleteItem(id);

  // Banks
  Future<int> createBank({required String name, String? accountNumber}) async {
    final bankId = await _repository.insertBank({'name': name, 'account_number': accountNumber});
    await _linkService.createAndLink(module: 'banks', entityType: 'Bank', entityId: bankId.toString(), entityName: name, parentSystemCode: 'bank_default');
    return bankId;
  }
  Future<List<Map<String, dynamic>>> getAllBanks() async => _repository.getAllBanks();
  Future<int> deleteBank(int id) async => _repository.deleteBank(id);

  // Cash Boxes
  Future<int> createCashBox({required String name}) async {
    final cashBoxId = await _repository.insertCashBox({'name': name});
    await _linkService.createAndLink(module: 'cash_boxes', entityType: 'CashBox', entityId: cashBoxId.toString(), entityName: name, parentSystemCode: 'cash_default');
    return cashBoxId;
  }
  Future<List<Map<String, dynamic>>> getAllCashBoxes() async => _repository.getAllCashBoxes();
  Future<int> deleteCashBox(int id) async => _repository.deleteCashBox(id);

  // Wallets
  Future<int> createWallet({required String name, String? provider}) async {
    final walletId = await _repository.insertWallet({'name': name, 'provider': provider});
    await _linkService.createAndLink(module: 'wallets', entityType: 'Wallet', entityId: walletId.toString(), entityName: name, parentSystemCode: 'wallet_parent');
    return walletId;
  }
  Future<List<Map<String, dynamic>>> getAllWallets() async => _repository.getAllWallets();
  Future<int> deleteWallet(int id) async => _repository.deleteWallet(id);

  // Exchange Companies
  Future<int> createExchangeCompany({required String name, String? phone}) async {
    final companyId = await _repository.insertExchangeCompany({'name': name, 'phone': phone});
    await _linkService.createAndLink(module: 'exchange_companies', entityType: 'ExchangeCompany', entityId: companyId.toString(), entityName: name, parentSystemCode: 'exchange_parent');
    return companyId;
  }
  Future<List<Map<String, dynamic>>> getAllExchangeCompanies() async => _repository.getAllExchangeCompanies();
  Future<int> deleteExchangeCompany(int id) async => _repository.deleteExchangeCompany(id);

  // Warehouses
  Future<int> createWarehouse({required String name, String? location}) async {
    final warehouseId = await _repository.insertWarehouse({'name': name, 'location': location});
    await _linkService.createAndLink(module: 'warehouses', entityType: 'Warehouse', entityId: warehouseId.toString(), entityName: name, parentSystemCode: 'inventory_default');
    return warehouseId;
  }
  Future<List<Map<String, dynamic>>> getAllWarehouses() async => _repository.getAllWarehouses();
  Future<int> deleteWarehouse(int id) async => _repository.deleteWarehouse(id);

  // Units
  Future<int> createUnit({required String name, String? abbreviation}) async => _repository.insertUnit({'name': name, 'abbreviation': abbreviation});
  Future<List<Map<String, dynamic>>> getAllUnits() async => _repository.getAllUnits();
  Future<int> deleteUnit(int id) async => _repository.deleteUnit(id);

  // Currencies
  Future<int> createCurrency({required String code, required String name}) async => _repository.insertCurrency({'code': code, 'name': name});
  Future<List<Map<String, dynamic>>> getAllCurrencies() async => _repository.getAllCurrencies();
  Future<int> deleteCurrency(int id) async => _repository.deleteCurrency(id);

  // Accounts
  Future<List<Map<String, dynamic>>> getAllAccounts() async => _repository.getAllAccounts();
  Future<int?> getLinkedAccountId(String module, String entityType, String entityId) async => _linkService.getLinkedAccount(module, entityType, entityId);
}
