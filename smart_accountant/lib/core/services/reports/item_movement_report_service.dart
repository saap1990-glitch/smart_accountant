import '../../database/app_database.dart';

class ItemMovementReportService {

  final AppDatabase db;

  ItemMovementReportService(this.db);


  Future<List<Map<String, dynamic>>> generate({
    required int itemId,
  }) async {

    final rows = await db.select(db.inventoryTransactions).get();


    return rows
        .where((e) => e.itemId == itemId)
        .map((e) => {
              'date': e.date,
              'warehouseId': e.warehouseId,
              'type': e.type,
              'quantity': e.quantity,
              'cost': e.cost,
            })
        .toList();
  }
}
