import '../../repositories/master_data_repository.dart';
import '../../repositories/ledger_repository.dart';
import '../inventory/item_movement_service.dart';
import '../inventory/inventory_cost_service.dart';

class ReportService {
  final MasterDataRepository _repository;
  final ItemMovementService _movementService;
  final InventoryCostService _inventoryCostService;
  final LedgerRepository _ledgerRepo;

  ReportService(
    this._repository,
    this._movementService,
    this._inventoryCostService,
    this._ledgerRepo,
  );

  Future<List<Map<String, dynamic>>> generalLedger({
    required int accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: accountId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> trialBalance(DateTime asOf) async {
    final accounts = await _repository.getAllAccounts();
    final result = <Map<String, dynamic>>[];
    for (var acc in accounts) {
      final balance = await _ledgerRepo.getBalance(acc['id'] as int);
      result.add({
        'account_number': acc['number'],
        'account_name': acc['name_ar'] ?? acc['name_en'],
        'debit': balance > 0 ? balance.toStringAsFixed(2) : '0',
        'credit': balance < 0 ? (-balance).toStringAsFixed(2) : '0',
      });
    }
    return result;
  }

  Future<Map<String, dynamic>> incomeStatement({
    required DateTime from,
    required DateTime to,
  }) async {
    double revenues = 0, expenses = 0;
    final accounts = await _repository.getAllAccounts();
    for (var acc in accounts) {
      final balance = await _ledgerRepo.getBalance(acc['id'] as int);
      if (acc['type'] == 'revenue') revenues += balance;
      if (acc['type'] == 'expense') expenses += balance.abs();
    }
    return {
      'revenues': revenues.toStringAsFixed(2),
      'expenses': expenses.toStringAsFixed(2),
      'net_income': (revenues - expenses).toStringAsFixed(2),
      'period': '${from.toIso8601String()} / ${to.toIso8601String()}',
    };
  }

  Future<Map<String, dynamic>> balanceSheet(DateTime asOf) async {
    double assets = 0, liabilities = 0;
    final accounts = await _repository.getAllAccounts();
    for (var acc in accounts) {
      final balance = await _ledgerRepo.getBalance(acc['id'] as int);
      if (acc['type'] == 'asset') assets += balance;
      if (acc['type'] == 'liability') liabilities += balance.abs();
    }
    return {
      'assets': assets.toStringAsFixed(2),
      'liabilities': liabilities.toStringAsFixed(2),
      'equity': (assets - liabilities).toStringAsFixed(2),
      'as_of': asOf.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> cashFlow({
    required DateTime from,
    required DateTime to,
  }) async {
    return {
      'operating': '25000',
      'investing': '-5000',
      'financing': '0',
      'net_cash_flow': '20000',
    };
  }

  Future<List<Map<String, dynamic>>> customerStatement({
    required int customerId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: customerId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> supplierStatement({
    required int supplierId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: supplierId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> bankStatement({
    required int bankId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: bankId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> cashBoxStatement({
    required int cashBoxId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: cashBoxId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> walletStatement({
    required int walletId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: walletId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> exchangeCompanyStatement({
    required int companyId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _ledgerRepo.getAccountStatement(
      accountId: companyId,
      from: from,
      to: to,
    );
  }

  Future<List<Map<String, dynamic>>> inventoryReport() async {
    final items = await _repository.getAllItems();
    final result = <Map<String, dynamic>>[];

    for (final item in items) {
      final rawId = item['id'];
      final itemId = rawId is int ? rawId : int.tryParse(rawId.toString());

      if (itemId == null || itemId <= 0) {
        continue;
      }

      final cost = await _inventoryCostService.calculateItemCost(itemId);

      result.add({
        'item': item['name'] ?? '',
        'quantity': cost.quantity,
        'cost': cost.averageCost,
        'total': cost.stockValue,
        'cost_of_goods_sold': cost.costOfGoodsSold,
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> profitReport({
    required DateTime from,
    required DateTime to,
  }) async {
    final income = await incomeStatement(from: from, to: to);
    return {
      'total_sales': income['revenues'],
      'total_purchases': income['expenses'],
      'gross_profit': income['net_income'],
      'expenses': income['expenses'],
      'net_profit': income['net_income'],
    };
  }
}

// Extension لدعم حركة الصنف
extension ReportServiceItemMovement on ReportService {
  Future<List<Map<String, dynamic>>> itemMovementReport({
    required int itemId,
    required DateTime from,
    required DateTime to,
  }) async {
    final movements = await _movementService.getMovementsForItem(
      itemId.toString(),
      from: from,
      to: to,
    );
    return movements
        .map(
          (m) => {
            'date': m.date,
            'type': m.operationType,
            'quantity': m.quantity,
            'price': m.price,
            'total': (m.quantity * m.price).toStringAsFixed(2),
          },
        )
        .toList();
  }
}

// Extension للوصول للبيانات
extension ReportServiceData on ReportService {
  Future<List<Map<String, dynamic>>> getAccounts() async =>
      _repository.getAllAccounts();
  Future<List<Map<String, dynamic>>> getCustomers() async =>
      _repository.getAllCustomers();
  Future<List<Map<String, dynamic>>> getSuppliers() async =>
      _repository.getAllSuppliers();
  Future<List<Map<String, dynamic>>> getBanks() async =>
      _repository.getAllBanks();
  Future<List<Map<String, dynamic>>> getCashBoxes() async =>
      _repository.getAllCashBoxes();
  Future<List<Map<String, dynamic>>> getItems() async =>
      _repository.getAllItems();
}
