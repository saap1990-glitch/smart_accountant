import '../../database/app_database.dart';

class OperationNumberService {
  final AppDatabase db;

  OperationNumberService(this.db);

  Future<String> generate({
    required String prefix,
    required String type,
  }) async {
    final year = DateTime.now().year;

    final docs = await (db.select(db.documents)
          ..where((t) => t.type.equals(type)))
        .get();

    final next = docs.length + 1;

    final serial = next.toString().padLeft(6, '0');

    return '$prefix-$year-$serial';
  }
}
