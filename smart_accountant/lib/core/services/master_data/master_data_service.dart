import '../../repositories/master_data_repository.dart';
import '../accounting/accounting_link_service.dart';

class MasterDataService {
  final MasterDataRepository _repository;
  final AccountingLinkService _linkService;

  MasterDataService(this._repository, this._linkService);

  // ========== العملاء ==========
  Future<int> createCustomer({
    required String name,
    String? phone,
    String? address,
  }) async {
    // 1. إنشاء العميل في جدول العملاء
    final customerId = await _repository.insertCustomer({
      'name': name,
      'phone': phone,
      'address': address,
    });

    // 2. إنشاء حساب محاسبي تلقائياً تحت "العملاء"
    await _linkService.createAndLink(
      module: 'customers',
      entityType: 'Customer',
      entityId: customerId.toString(),
      entityName: name,
      parentSystemCode: 'customer_parent',
    );

    return customerId;
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async =>
      _repository.getAllCustomers();

  // ========== الموردين ==========
  Future<int> createSupplier({
    required String name,
    String? phone,
    String? address,
  }) async {
    final supplierId = await _repository.insertSupplier({
      'name': name,
      'phone': phone,
      'address': address,
    });

    await _linkService.createAndLink(
      module: 'suppliers',
      entityType: 'Supplier',
      entityId: supplierId.toString(),
      entityName: name,
      parentSystemCode: 'supplier_parent',
    );

    return supplierId;
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async =>
      _repository.getAllSuppliers();

  // ========== الأصناف ==========
  Future<int> createItem({
    required String name,
    required String unit,
    double? cost,
    double? price,
  }) async {
    return _repository.insertItem({
      'name': name,
      'unit': unit,
      'cost': cost,
      'price': price,
    });
  }

  Future<List<Map<String, dynamic>>> getAllItems() async =>
      _repository.getAllItems();

  // ========== البنوك ==========
  Future<int> createBank({
    required String name,
    String? accountNumber,
  }) async {
    final bankId = await _repository.insertBank({
      'name': name,
      'account_number': accountNumber,
    });

    await _linkService.createAndLink(
      module: 'banks',
      entityType: 'Bank',
      entityId: bankId.toString(),
      entityName: name,
      parentSystemCode: 'bank_default',
    );

    return bankId;
  }

  Future<List<Map<String, dynamic>>> getAllBanks() async =>
      _repository.getAllBanks();

  // ========== الصناديق ==========
  Future<int> createCashBox({required String name}) async {
    final cashBoxId = await _repository.insertCashBox({'name': name});

    await _linkService.createAndLink(
      module: 'cash_boxes',
      entityType: 'CashBox',
      entityId: cashBoxId.toString(),
      entityName: name,
      parentSystemCode: 'cash_default',
    );

    return cashBoxId;
  }

  Future<List<Map<String, dynamic>>> getAllCashBoxes() async =>
      _repository.getAllCashBoxes();

  // ========== المحافظ ==========
  Future<int> createWallet({required String name, String? provider}) async {
    final walletId = await _repository.insertWallet({
      'name': name,
      'provider': provider,
    });

    await _linkService.createAndLink(
      module: 'wallets',
      entityType: 'Wallet',
      entityId: walletId.toString(),
      entityName: name,
      parentSystemCode: 'wallet_parent',
    );

    return walletId;
  }

  Future<List<Map<String, dynamic>>> getAllWallets() async =>
      _repository.getAllWallets();

  // ========== شركات الصرافة ==========
  Future<int> createExchangeCompany({required String name, String? phone}) async {
    final companyId = await _repository.insertExchangeCompany({
      'name': name,
      'phone': phone,
    });

    await _linkService.createAndLink(
      module: 'exchange_companies',
      entityType: 'ExchangeCompany',
      entityId: companyId.toString(),
      entityName: name,
      parentSystemCode: 'exchange_parent',
    );

    return companyId;
  }

  Future<List<Map<String, dynamic>>> getAllExchangeCompanies() async =>
      _repository.getAllExchangeCompanies();

  // ========== المخازن ==========
  Future<int> createWarehouse({required String name, String? location}) async {
    final warehouseId = await _repository.insertWarehouse({
      'name': name,
      'location': location,
    });

    await _linkService.createAndLink(
      module: 'warehouses',
      entityType: 'Warehouse',
      entityId: warehouseId.toString(),
      entityName: name,
      parentSystemCode: 'inventory_default',
    );

    return warehouseId;
  }

  Future<List<Map<String, dynamic>>> getAllWarehouses() async =>
      _repository.getAllWarehouses();

  // ========== الوحدات ==========
  Future<int> createUnit({required String name, String? abbreviation}) async =>
      _repository.insertUnit({'name': name, 'abbreviation': abbreviation});

  Future<List<Map<String, dynamic>>> getAllUnits() async =>
      _repository.getAllUnits();

  // ========== العملات ==========
  Future<int> createCurrency({required String code, required String name}) async =>
      _repository.insertCurrency({'code': code, 'name': name});

  Future<List<Map<String, dynamic>>> getAllCurrencies() async =>
      _repository.getAllCurrencies();

  // ========== الحسابات ==========
  Future<List<Map<String, dynamic>>> getAllAccounts() async =>
      _repository.getAllAccounts();

  // ========== الحسابات المرتبطة ==========
  Future<int?> getLinkedAccountId(String module, String entityType, String entityId) async =>
      _linkService.getLinkedAccount(module, entityType, entityId);
}
