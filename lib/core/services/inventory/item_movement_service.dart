import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class ItemMovementRecord {
  final String itemId;
  final String itemName;
  final double quantity;
  final double price;
  final String operationType;
  final DateTime date;
  final String? reference;

  const ItemMovementRecord({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.operationType,
    required this.date,
    this.reference,
  });
}

class ItemMovementService {
  final AppDatabase _db;

  ItemMovementService(this._db);

  Future<void> recordMovement({
    required String itemId,
    required String itemName,
    required double quantity,
    required double price,
    required String operationType,
    String? reference,
    DateTime? date,
  }) async {
    final parsedItemId = int.tryParse(itemId);

    if (parsedItemId == null || parsedItemId <= 0) {
      throw ArgumentError('معرف الصنف غير صحيح');
    }

    if (quantity <= 0) {
      throw ArgumentError('كمية الحركة يجب أن تكون أكبر من صفر');
    }

    await _db
        .into(_db.inventoryTransactions)
        .insert(
          InventoryTransactionsCompanion.insert(
            itemId: parsedItemId,
            type: operationType,
            quantity: quantity.toString(),
            price: Value(price.toString()),
            reference: Value(reference),
            date: date ?? DateTime.now(),
          ),
        );
  }

  Future<List<ItemMovementRecord>> getMovementsForItem(
    String itemId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final parsedItemId = int.tryParse(itemId);

    if (parsedItemId == null || parsedItemId <= 0) {
      return [];
    }

    final query = _db.select(_db.inventoryTransactions)
      ..where((t) => t.itemId.equals(parsedItemId))
      ..orderBy([
        (t) => OrderingTerm.asc(t.date),
        (t) => OrderingTerm.asc(t.id),
      ]);

    if (from != null) {
      query.where((t) => t.date.isBiggerOrEqualValue(from));
    }

    if (to != null) {
      query.where((t) => t.date.isSmallerOrEqualValue(to));
    }

    final rows = await query.get();

    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(parsedItemId))).getSingleOrNull();

    final itemName = item?.name ?? '';

    return rows.map((m) {
      return ItemMovementRecord(
        itemId: m.itemId.toString(),
        itemName: itemName,
        quantity: double.tryParse(m.quantity) ?? 0,
        price: double.tryParse(m.price ?? '0') ?? 0,
        operationType: m.type,
        date: m.date,
        reference: m.reference,
      );
    }).toList();
  }

  Future<Map<String, dynamic>> getItemCard(
    String itemId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final movements = await getMovementsForItem(itemId, from: from, to: to);

    double purchases = 0;
    double sales = 0;
    double returns = 0;
    double adjustments = 0;

    double purchaseCost = 0;
    double salesCost = 0;

    for (final movement in movements) {
      switch (movement.operationType) {
        case 'purchase':
          purchases += movement.quantity;
          purchaseCost += movement.quantity * movement.price;
          break;

        case 'sale':
          sales += movement.quantity;
          salesCost += movement.quantity * movement.price;
          break;

        case 'return':
        case 'sale_return':
        case 'purchase_return':
          returns += movement.quantity;
          break;

        case 'inventory':
        case 'inventory_in':
        case 'inventory_out':
          adjustments += movement.quantity;
          break;
      }
    }

    final balance = purchases - sales + returns + adjustments;

    final averageCost = purchases > 0 ? purchaseCost / purchases : 0.0;

    return {
      'item_id': itemId,
      'item_name': movements.isNotEmpty ? movements.first.itemName : '',
      'opening': 0.0,
      'purchases': purchases,
      'sales': sales,
      'returns': returns,
      'adjustments': adjustments,
      'balance': balance,
      'purchase_cost': purchaseCost,
      'sales_cost': salesCost,
      'average_cost': averageCost,
      'stock_value': balance * averageCost,
      'movements': movements,
    };
  }

  Future<List<Map<String, dynamic>>> getAllItemCards() async {
    final items = await _db.select(_db.items).get();

    final result = <Map<String, dynamic>>[];

    for (final item in items) {
      result.add(await getItemCard(item.id.toString()));
    }

    return result;
  }

  Future<double> getAvailableQuantity(String itemId) async {
    final card = await getItemCard(itemId);
    return (card['balance'] as num?)?.toDouble() ?? 0;
  }

  Future<double> getAverageCost(String itemId) async {
    final card = await getItemCard(itemId);
    return (card['average_cost'] as num?)?.toDouble() ?? 0;
  }
}
