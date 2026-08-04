import '../../repositories/accounting/journal_repository.dart';
import '../mappers/journal_mapper.dart';
import '../models/accounting_entry.dart';
import '../results/posting_result.dart';

class PostingEngine {
  final JournalRepository journalRepository;
  final JournalMapper mapper;

  const PostingEngine({required this.journalRepository, required this.mapper});

  Future<PostingResult> post(AccountingEntry entry) async {
    if (!entry.isBalanced) {
      return PostingResult.failure('لا يمكن ترحيل قيد غير متوازن');
    }

    try {
      final journalId = await journalRepository.createEntry(
        reference: entry.reference,
        description: entry.description,
        date: entry.date,
        currency: entry.lines.first.currencyCode,
        exchangeRate: entry.lines.first.exchangeRate,
        lines: const [],
      );

      final lines = mapper.toLines(entry: entry, journalId: journalId);

      await journalRepository.db.batch((batch) {
        batch.insertAll(journalRepository.db.journalLines, lines);
      });

      return PostingResult.success(journalId);
    } catch (e) {
      return PostingResult.failure(e.toString());
    }
  }
}
