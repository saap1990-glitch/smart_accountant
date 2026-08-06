import '../inventory/inventory_operation_service.dart';
import '../accounting/accounting_service.dart';
import '../../accounting/models/accounting_entry.dart';
import '../../accounting/models/accounting_line.dart';

class InventoryAccountingBridge {

  final InventoryOperationService inventory;
  final AccountingService accounting;

  InventoryAccountingBridge(
    this.inventory,
    this.accounting,
  );


  Future<int> stockReceipt({
    required int itemId,
    required int warehouseId,
    required double quantity,
    required double cost,
    required int inventoryAccountId,
    required int cashOrSupplierAccountId,
    required String currency,
  }) async {

    final stockId = await inventory.stockIn(
      itemId: itemId,
      warehouseId: warehouseId,
      quantity: quantity,
      cost: cost,
    );


    final entry = AccountingEntry(
      reference: 'STOCK_RECEIPT_$stockId',
      description: 'Stock Receipt',
      date: DateTime.now(),
      lines: [
        AccountingLine(
          accountId: inventoryAccountId,
          debit: quantity * cost,
          credit: 0,
          currencyCode: currency,
          exchangeRate: 1,
        ),
        AccountingLine(
          accountId: cashOrSupplierAccountId,
          debit: 0,
          credit: quantity * cost,
          currencyCode: currency,
          exchangeRate: 1,
        ),
      ],
    );


    await accounting.postEntry(
      entry: entry,
      currency: currency,
      exchangeRate: 1,
    );


    return stockId;
  }
}
