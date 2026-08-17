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
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: accountId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> trialBalance(
    DateTime asOf, {
    String? currencyCode,
  }) async {
    final accounts = await _repository.getAllAccounts();
    final result = <Map<String, dynamic>>[];

    double totalDebit = 0;
    double totalCredit = 0;

    for (final account in accounts) {
      final id = _int(account['id']);
      if (id == null) continue;

      final totals = await _ledgerRepo.getTotals(
        id,
        to: asOf,
        currencyCode: currencyCode,
      );

      final debit = totals['debit'] ?? 0;
      final credit = totals['credit'] ?? 0;
      final balance = debit - credit;

      if (debit == 0 && credit == 0) continue;

      totalDebit += debit;
      totalCredit += credit;

      result.add({
        'account_id': id,
        'account_number': account['number'],
        'account_name': account['name_ar'] ?? account['name_en'] ?? '',
        'type': account['type'],
        'debit': debit,
        'credit': credit,
        'balance': balance,
      });
    }

    result.add({
      'is_total': true,
      'account_name': 'الإجمالي',
      'debit': totalDebit,
      'credit': totalCredit,
      'balance': totalDebit - totalCredit,
    });

    return result;
  }

  Future<Map<String, dynamic>> incomeStatement({
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) async {
    double revenues = 0;
    double expenses = 0;

    final revenueAccounts = <Map<String, dynamic>>[];
    final expenseAccounts = <Map<String, dynamic>>[];

    final accounts = await _repository.getAllAccounts();

    for (final account in accounts) {
      final id = _int(account['id']);
      if (id == null) continue;

      final type = _type(account['type']);

      if (type != 'revenue' && type != 'expense') {
        continue;
      }

      final totals = await _ledgerRepo.getTotals(
        id,
        from: from,
        to: to,
        currencyCode: currencyCode,
      );

      final debit = totals['debit'] ?? 0;
      final credit = totals['credit'] ?? 0;

      double amount;

      if (type == 'revenue') {
        amount = credit - debit;
        revenues += amount;
      } else {
        amount = debit - credit;
        expenses += amount;
      }

      final row = {
        'account_id': id,
        'account_number': account['number'],
        'account_name': account['name_ar'] ?? account['name_en'] ?? '',
        'debit': debit,
        'credit': credit,
        'amount': amount,
      };

      if (type == 'revenue') {
        revenueAccounts.add(row);
      } else {
        expenseAccounts.add(row);
      }
    }

    return {
      'from': from,
      'to': to,
      'revenues': revenues,
      'expenses': expenses,
      'net_income': revenues - expenses,
      'revenue_accounts': revenueAccounts,
      'expense_accounts': expenseAccounts,
    };
  }

  Future<Map<String, dynamic>> balanceSheet(
    DateTime asOf, {
    String? currencyCode,
  }) async {
    double assets = 0;
    double liabilities = 0;

    final assetAccounts = <Map<String, dynamic>>[];
    final liabilityAccounts = <Map<String, dynamic>>[];

    final accounts = await _repository.getAllAccounts();

    for (final account in accounts) {
      final id = _int(account['id']);
      if (id == null) continue;

      final type = _type(account['type']);

      if (type != 'asset' && type != 'liability') {
        continue;
      }

      final balance = await _ledgerRepo.getBalance(
        id,
        asOf: asOf,
        currencyCode: currencyCode,
      );

      final row = {
        'account_id': id,
        'account_number': account['number'],
        'account_name': account['name_ar'] ?? account['name_en'] ?? '',
        'balance': balance,
      };

      if (type == 'asset') {
        assets += balance;
        assetAccounts.add(row);
      } else {
        liabilities += -balance;
        liabilityAccounts.add(row);
      }
    }

    /*
     * حقوق الملكية الاقتصادية:
     *
     * Equity = Assets - Liabilities
     *
     * وهذا يعكس أيضًا نتيجة الأعمال المتراكمة
     * من واقع القيود، بدلاً من وضع رقم افتراضي.
     */
    final equity = assets - liabilities;

    return {
      'as_of': asOf,
      'assets': assets,
      'liabilities': liabilities,
      'equity': equity,
      'asset_accounts': assetAccounts,
      'liability_accounts': liabilityAccounts,
      'balanced': (assets - (liabilities + equity)).abs() < 0.001,
    };
  }

  Future<Map<String, dynamic>> cashFlow({
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) async {
    /*
     * التدفق النقدي الحقيقي:
     *
     * نبحث عن الحسابات النقدية الفعلية من شجرة الحسابات.
     * لا توجد أرقام ثابتة.
     *
     * التصنيف التفصيلي operating/investing/financing
     * يحتاج إلى ربط حسابات النظام بالتصنيف.
     * لذلك لا نخترع تصنيفًا إذا لم يكن الربط موجودًا.
     */

    final accounts = await _repository.getAllAccounts();

    double openingCash = 0;
    double closingCash = 0;
    double periodDebit = 0;
    double periodCredit = 0;

    final cashAccounts = <Map<String, dynamic>>[];

    for (final account in accounts) {
      final id = _int(account['id']);
      if (id == null) continue;

      final number = '${account['number'] ?? ''}'.toLowerCase();
      final name = '${account['name_ar'] ?? account['name_en'] ?? ''}'
          .toLowerCase();

      final isCashLike =
          name.contains('نقد') ||
          name.contains('خزينة') ||
          name.contains('صندوق') ||
          name.contains('بنك') ||
          name.contains('محفظ') ||
          name.contains('cash') ||
          name.contains('bank') ||
          name.contains('wallet') ||
          number.startsWith('1101') ||
          number.startsWith('1102') ||
          number.startsWith('1103') ||
          number.startsWith('1104');

      if (!isCashLike) continue;

      final opening = await _ledgerRepo.getBalance(
        id,
        asOf: from.subtract(const Duration(microseconds: 1)),
        currencyCode: currencyCode,
      );

      final closing = await _ledgerRepo.getBalance(
        id,
        asOf: to,
        currencyCode: currencyCode,
      );

      final totals = await _ledgerRepo.getTotals(
        id,
        from: from,
        to: to,
        currencyCode: currencyCode,
      );

      openingCash += opening;
      closingCash += closing;
      periodDebit += totals['debit'] ?? 0;
      periodCredit += totals['credit'] ?? 0;

      cashAccounts.add({
        'account_id': id,
        'account_number': account['number'],
        'account_name': account['name_ar'] ?? account['name_en'] ?? '',
        'opening': opening,
        'debit': totals['debit'] ?? 0,
        'credit': totals['credit'] ?? 0,
        'closing': closing,
      });
    }

    return {
      'from': from,
      'to': to,
      'opening_cash': openingCash,
      'cash_in': periodDebit,
      'cash_out': periodCredit,
      'net_cash_flow': closingCash - openingCash,
      'closing_cash': closingCash,
      'accounts': cashAccounts,
    };
  }

  Future<List<Map<String, dynamic>>> customerStatement({
    required int customerId,
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: customerId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> supplierStatement({
    required int supplierId,
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: supplierId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> bankStatement({
    required int bankId,
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: bankId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> cashBoxStatement({
    required int cashBoxId,
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: cashBoxId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> walletStatement({
    required int walletId,
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: walletId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> exchangeCompanyStatement({
    required int companyId,
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) {
    return _ledgerRepo.getAccountStatement(
      accountId: companyId,
      from: from,
      to: to,
      currencyCode: currencyCode,
    );
  }

  Future<List<Map<String, dynamic>>> inventoryReport() async {
    final items = await _repository.getAllItems();
    final result = <Map<String, dynamic>>[];

    for (final item in items) {
      final itemId = _int(item['id']);
      if (itemId == null || itemId <= 0) continue;

      final cost = await _inventoryCostService.calculateItemCost(itemId);

      result.add({
        'item_id': itemId,
        'item': item['name'] ?? '',
        'quantity': cost.quantity,
        'average_cost': cost.averageCost,
        'total_value': cost.stockValue,
        'cost_of_goods_sold': cost.costOfGoodsSold,
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> profitReport({
    required DateTime from,
    required DateTime to,
    String? currencyCode,
  }) async {
    final income = await incomeStatement(
      from: from,
      to: to,
      currencyCode: currencyCode,
    );

    return {
      'from': from,
      'to': to,
      'total_revenues': income['revenues'],
      'total_expenses': income['expenses'],
      'net_profit': income['net_income'],
      'revenue_accounts': income['revenue_accounts'],
      'expense_accounts': income['expense_accounts'],
    };
  }

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

    return movements.map((e) {
      final total = e.quantity * e.price;

      return {
        'date': e.date,
        'item_id': e.itemId,
        'item_name': e.itemName,
        'type': e.operationType,
        'quantity': e.quantity,
        'price': e.price,
        'total': total,
        'reference': e.reference,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    return _repository.getAllAccounts();
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    return _repository.getAllCustomers();
  }

  Future<List<Map<String, dynamic>>> getSuppliers() async {
    return _repository.getAllSuppliers();
  }

  Future<List<Map<String, dynamic>>> getBanks() async {
    return _repository.getAllBanks();
  }

  Future<List<Map<String, dynamic>>> getCashBoxes() async {
    return _repository.getAllCashBoxes();
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    return _repository.getAllItems();
  }

  int? _int(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  String _type(dynamic value) {
    return value?.toString().trim().toLowerCase() ?? '';
  }
}
