import 'package:get_it/get_it.dart';
import '../../repositories/master_data_repository.dart';
import '../../repositories/ledger_repository.dart';
import '../../repositories/journal_repository.dart';
import '../numbering/number_generator.dart';

class InventoryCountService {
  final MasterDataRepository _repo;
  final LedgerRepository _ledgerRepo;
  final JournalRepository _journalRepo;
  final NumberGenerator _numberGen;

  InventoryCountService(this._repo, this._ledgerRepo, this._journalRepo, this._numberGen);

  /// إجراء جرد فعلي - تحديث أرصدة المخزون
  Future<Map<String, dynamic>> performCount({
    required int warehouseId,
    required List<Map<String, dynamic>> items, // [{itemId, expectedQty, actualQty}]
    String? notes,
  }) async {
    final adjustments = <Map<String, dynamic>>[];
    double totalDifference = 0;

    for (var item in items) {
      final expected = double.tryParse(item['expectedQty']?.toString() ?? '0') ?? 0;
      final actual = double.tryParse(item['actualQty']?.toString() ?? '0') ?? 0;
      final difference = actual - expected;

      if (difference != 0) {
        adjustments.add({
          'itemId': item['itemId'],
          'difference': difference,
          'type': difference > 0 ? 'increase' : 'decrease',
        });
        totalDifference += difference;
      }
    }

    // إذا كانت هناك فروقات، أنشئ قيد تسوية
    if (adjustments.isNotEmpty) {
      final number = await _numberGen.generate('inventory');
      // قيد التسوية: مخزون مدين/دائن مقابل حساب الفروقات
      final items = <Map<String, dynamic>>[
        {'accountId': 113, 'debit': totalDifference > 0 ? totalDifference : 0, 'credit': totalDifference < 0 ? -totalDifference : 0},
        {'accountId': 4, 'debit': totalDifference < 0 ? -totalDifference : 0, 'credit': totalDifference > 0 ? totalDifference : 0},
      ];

      await _journalRepo.saveJournalEntry(
        entryNumber: number,
        entryDate: DateTime.now(),
        operationType: 'inventory_count',
        description: 'تسوية جرد - $notes',
        referenceType: 'inventory',
        referenceId: warehouseId.toString(),
        currencyCode: 'YER',
        exchangeRate: 1.0,
        lines: items,
      );
    }

    return {
      'adjustments': adjustments.length,
      'totalDifference': totalDifference,
      'number': adjustments.isNotEmpty ? 'INV-${DateTime.now().year}' : null,
    };
  }

  /// الإغلاق السنوي - تصفير حسابات الإيرادات والمصروفات
  Future<Map<String, dynamic>> closeYear() async {
    final accounts = await _repo.getAllAccounts();
    final revenues = accounts.where((a) => a['type'] == 'revenue').toList();
    final expenses = accounts.where((a) => a['type'] == 'expense').toList();

    double totalRevenues = 0;
    double totalExpenses = 0;

    for (var acc in revenues) {
      totalRevenues += await _ledgerRepo.getBalance(acc['id'] as int);
    }
    for (var acc in expenses) {
      totalExpenses += (await _ledgerRepo.getBalance(acc['id'] as int)).abs();
    }

    final netIncome = totalRevenues - totalExpenses;
    final number = await _numberGen.generate('year_close');

    // إنشاء قيد الإغلاق
    final lines = <Map<String, dynamic>>[];
    for (var acc in revenues) {
      final balance = await _ledgerRepo.getBalance(acc['id'] as int);
      if (balance != 0) {
        lines.add({'accountId': acc['id'], 'debit': balance, 'credit': 0});
      }
    }
    for (var acc in expenses) {
      final balance = (await _ledgerRepo.getBalance(acc['id'] as int)).abs();
      if (balance != 0) {
        lines.add({'accountId': acc['id'], 'debit': 0, 'credit': balance});
      }
    }
    // حساب الأرباح المحتجزة
    lines.add({'accountId': 2, 'debit': netIncome < 0 ? -netIncome : 0, 'credit': netIncome > 0 ? netIncome : 0});

    await _journalRepo.saveJournalEntry(
      entryNumber: number,
      entryDate: DateTime(DateTime.now().year, 12, 31),
      operationType: 'year_close',
      description: 'الإغلاق السنوي ${DateTime.now().year}',
      referenceType: 'year_close',
      referenceId: DateTime.now().year.toString(),
      currencyCode: 'YER',
      exchangeRate: 1.0,
      lines: lines,
    );

    return {
      'totalRevenues': totalRevenues,
      'totalExpenses': totalExpenses,
      'netIncome': netIncome,
      'number': number,
    };
  }
}
