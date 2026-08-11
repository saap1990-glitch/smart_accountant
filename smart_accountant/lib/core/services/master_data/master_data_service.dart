import 'package:get_it/get_it.dart';
import '../../repositories/master_data_repository.dart';

class MasterDataService {
  final MasterDataRepository _repository;

  MasterDataService(this._repository);

  // Accounts
  Future<int> createAccount({
    required String number,
    required String nameAr,
    String? nameEn,
    required String type,
    required String nature,
    int? parentId,
    int level = 1,
  }) async {
    return _repository.insertAccount({
      'number': number,
      'name_ar': nameAr,
      'name_en': nameEn,
      'type': type,
      'nature': nature,
      'parent_id': parentId,
      'level': level,
      'accepts_posting': level >= 4 ? true : false,
    });
  }

  Future<List<Map<String, dynamic>>> getAllAccounts() async =>
      _repository.getAllAccounts();

  // Customers
  Future<int> createCustomer({
    required String name,
    String? phone,
    String? address,
  }) async {
    return _repository.insertCustomer({
      'name': name,
      'phone': phone,
      'address': address,
    });
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async =>
      _repository.getAllCustomers();

  // Suppliers
  Future<int> createSupplier({
    required String name,
    String? phone,
    String? address,
  }) async {
    return _repository.insertSupplier({
      'name': name,
      'phone': phone,
      'address': address,
    });
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async =>
      _repository.getAllSuppliers();

  // Items
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

  // Banks
  Future<int> createBank({
    required String name,
    String? accountNumber,
  }) async {
    return _repository.insertBank({
      'name': name,
      'account_number': accountNumber,
    });
  }

  Future<List<Map<String, dynamic>>> getAllBanks() async =>
      _repository.getAllBanks();

  // Cash Boxes
  Future<int> createCashBox({required String name}) async =>
      _repository.insertCashBox({'name': name});

  Future<List<Map<String, dynamic>>> getAllCashBoxes() async =>
      _repository.getAllCashBoxes();

  // Warehouses
  Future<int> createWarehouse({required String name, String? location}) async =>
      _repository.insertWarehouse({'name': name, 'location': location});

  Future<List<Map<String, dynamic>>> getAllWarehouses() async =>
      _repository.getAllWarehouses();

  // Units
  Future<int> createUnit({required String name, String? abbreviation}) async =>
      _repository.insertUnit({'name': name, 'abbreviation': abbreviation});

  Future<List<Map<String, dynamic>>> getAllUnits() async =>
      _repository.getAllUnits();

  // Wallets
  Future<int> createWallet({required String name, String? provider}) async =>
      _repository.insertWallet({'name': name, 'provider': provider});

  Future<List<Map<String, dynamic>>> getAllWallets() async =>
      _repository.getAllWallets();

  // Exchange Companies
  Future<int> createExchangeCompany({required String name, String? phone}) async =>
      _repository.insertExchangeCompany({'name': name, 'phone': phone});

  Future<List<Map<String, dynamic>>> getAllExchangeCompanies() async =>
      _repository.getAllExchangeCompanies();

  // Currencies
  Future<int> createCurrency({required String code, required String name}) async =>
      _repository.insertCurrency({'code': code, 'name': name});

  Future<List<Map<String, dynamic>>> getAllCurrencies() async =>
      _repository.getAllCurrencies();
}
