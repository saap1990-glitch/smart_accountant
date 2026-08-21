import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import '../accounting/system_account_resolver.dart';

import '../../errors/result.dart';
import '../../errors/app_exception.dart';
import '../../database/app_database.dart';
import '../../engine/accounting/accounting_engine.dart';
import '../../engine/accounting/transaction_context.dart';
import '../../engine/accounting/transaction_result.dart';
import '../master_data/master_data_service.dart';
import '../inventory/item_movement_service.dart';
import '../inventory/inventory_movement_engine.dart';
import '../../repositories/ledger_repository.dart';

class OperationService {
  OperationService(
    this._engine,
    this._dataService,
    this._movementService,
    this._inventoryMovementEngine,
    this._db,
    this._ledgerRepo,
    this._systemResolver,
  );
  final AccountingEngine _engine;
  final MasterDataService _dataService;
  final ItemMovementService _movementService;
  final InventoryMovementEngine _inventoryMovementEngine;
  final AppDatabase _db;
  final LedgerRepository _ledgerRepo;
  final SystemAccountResolver _systemResolver;

  Future<Result<TransactionResult>> execute({
    SystemAccountResolver? systemResolver,
    required TransactionType type,
    required DateTime date,
    required List<JournalItem> items,
    String? reference,
    String? currencyCode,
    double exchangeRate = 1.0,
    Map<String, dynamic>? metadata,
  }) async {
    final resolver = systemResolver ?? GetIt.I<SystemAccountResolver>();
    for (final item in items) {
      if (item.accountId <= 0) {
        return const Failure(ValidationException('يجب اختيار جميع الحسابات'));
      }
    }

    double totalDebit = 0;
    double totalCredit = 0;

    for (final item in items) {
      totalDebit += item.debit;
      totalCredit += item.credit;
    }

    if ((totalDebit - totalCredit).abs() > 0.001) {
      return const Failure(ValidationException('القيد غير متوازن'));
    }

    final context = TransactionContext(
      type: type,
      date: date,
      items: items,
      reference: reference,
      currencyCode: currencyCode ?? 'YER',
      exchangeRate: exchangeRate,
      metadata: metadata,
    );

    try {
      return await _db.transaction(() async {
        final result = await _engine.execute(context);

        if (result is! Success<TransactionResult>) {
          return result;
        }

        if (metadata != null && metadata.containsKey('items')) {
          await _recordInventoryMovements(
            type: type,
            date: date,
            metadata: metadata,
          );
        }

        return result;
      });
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        AppException('فشل ترحيل العملية وإلغاء جميع التغييرات: $e'),
      );
    }
  }

  Future<void> _recordInventoryMovements({
    required TransactionType type,
    required DateTime date,
    required Map<String, dynamic> metadata,
  }) async {
    final rawItems = metadata['items'];

    if (rawItems is! List) {
      throw const ValidationException('بيانات أصناف العملية غير صحيحة');
    }

    for (final rawItem in rawItems) {
      if (rawItem is! Map) {
        throw const ValidationException('بيانات أحد أصناف العملية غير صحيحة');
      }

      final itemId = int.tryParse(rawItem['id']?.toString() ?? '');

      final quantity =
          double.tryParse(rawItem['quantity']?.toString() ?? '') ?? 0;

      final price = double.tryParse(rawItem['price']?.toString() ?? '') ?? 0;

      if (itemId == null || itemId <= 0) {
        throw const ValidationException('معرف الصنف غير صحيح');
      }

      if (quantity <= 0) {
        throw const ValidationException('كمية الصنف يجب أن تكون أكبر من صفر');
      }

      final reference = metadata['reference']?.toString();

      switch (type) {
        case TransactionType.sale:
          final isReturn = metadata['isReturn'] == true;

          if (isReturn) {
            final cost = await _getCurrentItemCost(itemId);

            await _inventoryMovementEngine.recordSaleReturn(
              itemId: itemId,
              quantity: quantity,
              cost: cost,
              reference: reference,
              date: date,
            );
          } else {
            await _inventoryMovementEngine.recordSale(
              itemId: itemId,
              quantity: quantity,
              price: price,
              reference: reference,
              date: date,
            );
          }
          break;

        case TransactionType.purchase:
          final isReturn = metadata['isReturn'] == true;

          if (isReturn) {
            final cost = await _getCurrentItemCost(itemId);

            await _inventoryMovementEngine.recordPurchaseReturn(
              itemId: itemId,
              quantity: quantity,
              cost: cost,
              reference: reference,
              date: date,
            );
          } else {
            await _inventoryMovementEngine.recordPurchase(
              itemId: itemId,
              quantity: quantity,
              price: price,
              reference: reference,
              date: date,
            );
          }
          break;

        case TransactionType.inventory:
          final inventoryIn = metadata['isInventoryIn'] == true;

          final inventoryOut = metadata['isInventoryOut'] == true;

          if (inventoryIn) {
            await _inventoryMovementEngine.recordInventoryIn(
              itemId: itemId,
              quantity: quantity,
              cost: price,
              reference: reference,
              date: date,
            );
          } else if (inventoryOut) {
            final cost = await _getCurrentItemCost(itemId);

            await _inventoryMovementEngine.recordInventoryOut(
              itemId: itemId,
              quantity: quantity,
              cost: cost,
              reference: reference,
              date: date,
            );
          }
          break;

        default:
          break;
      }
    }
  }

  Future<double> _getCurrentItemCost(int itemId) async {
    final rows = await (_db.select(
      _db.inventoryTransactions,
    )..where((t) => t.itemId.equals(itemId))).get();

    double quantity = 0;
    double value = 0;

    for (final row in rows) {
      final qty = double.tryParse(row.quantity) ?? 0;

      final price = double.tryParse(row.price ?? '0') ?? 0;

      switch (row.type.toLowerCase()) {
        case 'purchase':
        case 'inventory_in':
        case 'return_sale':
          quantity += qty;
          value += qty * price;
          break;

        case 'sale':
        case 'inventory_out':
        case 'return_purchase':
          if (quantity > 0) {
            final average = value / quantity;
            value -= qty * average;
            quantity -= qty;
          }
          break;
      }
    }

    if (quantity <= 0) {
      return 0;
    }

    return value / quantity;
  }

  Future<double> getAccountBalance(int accountId) async =>
      _ledgerRepo.getBalance(accountId);

  Future<List<Map<String, dynamic>>> getAccountStatement(
    int accountId, {
    DateTime? from,
    DateTime? to,
  }) async =>
      _ledgerRepo.getAccountStatement(accountId: accountId, from: from, to: to);

  Future<List<Map<String, dynamic>>> getAccounts() =>
      _dataService.getAllAccounts();

  Future<List<Map<String, dynamic>>> getCustomers() =>
      _dataService.getAllCustomers();

  Future<List<Map<String, dynamic>>> getSuppliers() =>
      _dataService.getAllSuppliers();

  Future<List<Map<String, dynamic>>> getItems() => _dataService.getAllItems();

  Future<List<Map<String, dynamic>>> getBanks() => _dataService.getAllBanks();

  Future<List<Map<String, dynamic>>> getCashBoxes() =>
      _dataService.getAllCashBoxes();

  Future<List<Map<String, dynamic>>> getWallets() =>
      _dataService.getAllWallets();

  Future<List<Map<String, dynamic>>> getExchangeCompanies() =>
      _dataService.getAllExchangeCompanies();
}

extension OperationServiceDraft on OperationService {
  Future<Result<TransactionResult>> saveDraft({
    required TransactionType type,
    required DateTime date,
    required List<JournalItem> items,
    String? reference,
    String? currencyCode,
    double exchangeRate = 1.0,
  }) async {
    final context = TransactionContext(
      type: type,
      date: date,
      items: items,
      reference: reference,
      currencyCode: currencyCode,
      exchangeRate: exchangeRate,
    );

    return _engine.saveAsDraft(context);
  }
}
