import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class DocumentRepository {
  final AppDatabase db;

  DocumentRepository(this.db);


  Future<int> createDocument({
    required String number,
    required String type,
    required int accountId,
    required String currency,
    required double exchangeRate,
    String? description,
  }) async {
    return db.into(db.documents).insert(
          DocumentsCompanion.insert(
            number: number,
            type: type,
            accountId: accountId,
            currency: currency,
            exchangeRate: Value(exchangeRate),
            description: Value(description),
          ),
        );
  }


  Future<void> addLine({
    required int documentId,
    required int accountId,
    int? itemId,
    double quantity = 0,
    double price = 0,
    double debit = 0,
    double credit = 0,
    String? description,
  }) async {
    await db.into(db.documentLines).insert(
          DocumentLinesCompanion.insert(
            documentId: documentId,
            accountId: accountId,
            itemId: Value(itemId),
            quantity: Value(quantity),
            price: Value(price),
            debit: Value(debit),
            credit: Value(credit),
            description: Value(description),
          ),
        );
  }


  Future<void> updateStatus(
    int id,
    String status,
  ) async {
    await (db.update(db.documents)
          ..where((t) => t.id.equals(id)))
        .write(
      DocumentsCompanion(
        status: Value(status),
      ),
    );
  }
}
