import '../../errors/result.dart';
import '../../errors/app_exception.dart';
import '../../engine/accounting/accounting_engine.dart';
import '../../engine/accounting/transaction_context.dart';
import '../../engine/accounting/transaction_result.dart';
import '../master_data/master_data_service.dart';
import '../inventory/item_movement_service.dart';
import '../../repositories/ledger_repository.dart';

class OperationService {
  final AccountingEngine _engine;
  final MasterDataService _dataService;
  final ItemMovementService _movementService;
  final LedgerRepository _ledgerRepo;

  OperationService(this._engine, this._dataService, this._movementService, this._ledgerRepo);

  Future<Result<TransactionResult>> execute({
    required TransactionType type,
    required DateTime date,
    required List<JournalItem> items,
    String? reference,
    String? currencyCode,
    double exchangeRate = 1.0,
    Map<String, dynamic>? metadata,
  }) async {
    for (final item in items) {
      if (item.accountId <= 0) {
        return const Failure(ValidationException('يجب اختيار جميع الحسابات'));
      }
    }

    double totalDebit = 0, totalCredit = 0;
    for (final item in items) {
      totalDebit += item.debit;
      totalCredit += item.credit;
    }
    if ((totalDebit - totalCredit).abs() > 0.001) {
      return Failure(ValidationException('القيد غير متوازن'));
    }

    final context = TransactionContext(type: type, date: date, items: items, reference: reference, currencyCode: currencyCode ?? 'YER', exchangeRate: exchangeRate, metadata: metadata);
    final result = await _engine.execute(context);

    if (result is Success<TransactionResult> && metadata != null && metadata.containsKey('items')) {
      _recordItemMovements(type, metadata);
    }

    return result;
  }

  void _recordItemMovements(TransactionType type, Map<String, dynamic> metadata) {
    final items = metadata['items'] as List<Map<String, dynamic>>;
    for (var item in items) {
      _movementService.recordMovement(
        itemId: item['id']?.toString() ?? '',
        itemName: item['name'] ?? '',
        quantity: (item['quantity'] as double?) ?? 0,
        price: (item['price'] as double?) ?? 0,
        operationType: type.name,
        reference: metadata['reference']?.toString(),
      );
    }
  }

  Future<double> getAccountBalance(int accountId) async => _ledgerRepo.getBalance(accountId);
  Future<List<Map<String, dynamic>>> getAccountStatement(int accountId, {DateTime? from, DateTime? to}) async => _ledgerRepo.getAccountStatement(accountId: accountId, from: from, to: to);
  Future<List<Map<String, dynamic>>> getAccounts() => _dataService.getAllAccounts();
  Future<List<Map<String, dynamic>>> getCustomers() => _dataService.getAllCustomers();
  Future<List<Map<String, dynamic>>> getSuppliers() => _dataService.getAllSuppliers();
  Future<List<Map<String, dynamic>>> getItems() => _dataService.getAllItems();
  Future<List<Map<String, dynamic>>> getBanks() => _dataService.getAllBanks();
  Future<List<Map<String, dynamic>>> getCashBoxes() => _dataService.getAllCashBoxes();
  Future<List<Map<String, dynamic>>> getWallets() => _dataService.getAllWallets();
  Future<List<Map<String, dynamic>>> getExchangeCompanies() => _dataService.getAllExchangeCompanies();
}

// Extension لدعم المسودات
extension OperationServiceDraft on OperationService {
  Future<Result<TransactionResult>> saveDraft({
    required TransactionType type,
    required DateTime date,
    required List<JournalItem> items,
    String? reference,
    String? currencyCode,
    double exchangeRate = 1.0,
  }) async {
    final context = TransactionContext(type: type, date: date, items: items, reference: reference, currencyCode: currencyCode, exchangeRate: exchangeRate);
    return _engine.saveAsDraft(context);
  }
}
