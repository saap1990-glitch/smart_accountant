import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class InventoryMovementEngine {
  final AppDatabase _db;

  InventoryMovementEngine(this._db);

  Future<void> record({
    required int itemId,
    required String type,
    required double quantity,
    double? price,
    String? reference,
    required DateTime date,
  }) async {
    if (itemId <= 0) {
      throw ArgumentError('معرف الصنف غير صحيح');
    }

    if (quantity <= 0) {
      throw ArgumentError('كمية حركة المخزون يجب أن تكون أكبر من صفر');
    }

    final normalizedType = _normalizeType(type);

    if (normalizedType == 'inventory_out' ||
        normalizedType == 'sale' ||
        normalizedType == 'return_purchase') {
      await _ensureAvailableStock(itemId: itemId, quantity: quantity);
    }

    await _db
        .into(_db.inventoryTransactions)
        .insert(
          InventoryTransactionsCompanion.insert(
            itemId: itemId,
            type: normalizedType,
            quantity: quantity.toString(),
            price: Value(price?.toString()),
            reference: Value(reference),
            date: date,
          ),
        );
  }

  Future<void> recordSale({
    required int itemId,
    required double quantity,
    required double price,
    String? reference,
    required DateTime date,
  }) {
    return record(
      itemId: itemId,
      type: 'sale',
      quantity: quantity,
      price: price,
      reference: reference,
      date: date,
    );
  }

  Future<void> recordPurchase({
    required int itemId,
    required double quantity,
    required double price,
    String? reference,
    required DateTime date,
  }) {
    return record(
      itemId: itemId,
      type: 'purchase',
      quantity: quantity,
      price: price,
      reference: reference,
      date: date,
    );
  }

  Future<void> recordSaleReturn({
    required int itemId,
    required double quantity,
    required double cost,
    String? reference,
    required DateTime date,
  }) {
    return record(
      itemId: itemId,
      type: 'return_sale',
      quantity: quantity,
      price: cost,
      reference: reference,
      date: date,
    );
  }

  Future<void> recordPurchaseReturn({
    required int itemId,
    required double quantity,
    required double cost,
    String? reference,
    required DateTime date,
  }) {
    return record(
      itemId: itemId,
      type: 'return_purchase',
      quantity: quantity,
      price: cost,
      reference: reference,
      date: date,
    );
  }

  Future<void> recordInventoryIn({
    required int itemId,
    required double quantity,
    double? cost,
    String? reference,
    required DateTime date,
  }) {
    return record(
      itemId: itemId,
      type: 'inventory_in',
      quantity: quantity,
      price: cost,
      reference: reference,
      date: date,
    );
  }

  Future<void> recordInventoryOut({
    required int itemId,
    required double quantity,
    double? cost,
    String? reference,
    required DateTime date,
  }) {
    return record(
      itemId: itemId,
      type: 'inventory_out',
      quantity: quantity,
      price: cost,
      reference: reference,
      date: date,
    );
  }

  Future<void> _ensureAvailableStock({
    required int itemId,
    required double quantity,
  }) async {
    final rows = await (_db.select(
      _db.inventoryTransactions,
    )..where((t) => t.itemId.equals(itemId))).get();

    double balance = 0;

    for (final row in rows) {
      final value = double.tryParse(row.quantity) ?? 0;

      switch (_normalizeType(row.type)) {
        case 'purchase':
        case 'inventory_in':
        case 'return_sale':
          balance += value;
          break;

        case 'sale':
        case 'inventory_out':
        case 'return_purchase':
          balance -= value;
          break;
      }
    }

    if (quantity > balance + 0.000001) {
      throw StateError(
        'الرصيد المخزني غير كافٍ للصنف $itemId. '
        'المتاح: ${balance.toStringAsFixed(3)} '
        'والمطلوب: ${quantity.toStringAsFixed(3)}',
      );
    }
  }

  String _normalizeType(String value) {
    switch (value.toLowerCase().trim()) {
      case 'purchase':
      case 'purchases':
        return 'purchase';

      case 'sale':
      case 'sales':
        return 'sale';

      case 'sale_return':
      case 'sales_return':
      case 'return_sale':
        return 'return_sale';

      case 'purchase_return':
      case 'purchases_return':
      case 'return_purchase':
        return 'return_purchase';

      case 'inventory_in':
      case 'stock_in':
        return 'inventory_in';

      case 'inventory_out':
      case 'stock_out':
        return 'inventory_out';

      default:
        return value.toLowerCase().trim();
    }
  }
}
