import '../../database/app_database.dart';
import 'package:drift/drift.dart';

class NumberGenerator {
  final AppDatabase _db;

  NumberGenerator(this._db);

  Future<String> generate(String type, {DateTime? date}) async {
    final operationDate = date ?? DateTime.now();
    final year = operationDate.year;
    final prefix = _getPrefix(type);
    final pattern = '$prefix-$year-';

    final entries = await (_db.select(
      _db.journalEntries,
    )..where((t) => t.entryNumber.like('$pattern%'))).get();

    var maxSequence = 0;

    for (final entry in entries) {
      if (!entry.entryNumber.startsWith(pattern)) continue;

      final suffix = entry.entryNumber.substring(pattern.length);
      final sequence = int.tryParse(suffix);

      if (sequence != null && sequence > maxSequence) {
        maxSequence = sequence;
      }
    }

    final nextSequence = maxSequence + 1;

    return '$pattern${nextSequence.toString().padLeft(6, '0')}';
  }

  String _getPrefix(String type) {
    switch (type.toLowerCase()) {
      case 'receipt':
        return 'RC';
      case 'payment':
        return 'PV';
      case 'sale':
        return 'SI';
      case 'purchase':
        return 'PI';
      case 'journal':
        return 'JV';
      case 'transfer':
        return 'TR';
      case 'inventory':
        return 'INV';
      default:
        return 'TX';
    }
  }
}
