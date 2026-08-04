import '../../accounting/mappers/journal_mapper.dart';
import '../../accounting/models/accounting_entry.dart';
import '../../accounting/validators/accounting_validator.dart';
import '../../database/app_database.dart';
import '../../repositories/accounting/journal_repository.dart';
import 'ledger_posting_service.dart';

class AccountingService {
  final JournalRepository journalRepository;
  final LedgerPostingService ledgerPostingService;
  final AccountingValidator validator;
  final JournalMapper mapper;

  AccountingService(AppDatabase db)
    : journalRepository = JournalRepository(db),
      ledgerPostingService = LedgerPostingService(db),
      validator = const AccountingValidator(),
      mapper = const JournalMapper();

  Future<int> postEntry({
    required AccountingEntry entry,
    required String currency,
    required double exchangeRate,
  }) async {
    validator.validate(entry);

    final lines = mapper.toJournalLines(entry);

    final journalId = await journalRepository.createEntry(
      reference: entry.reference,
      description: entry.description,
      date: entry.date,
      currency: currency,
      exchangeRate: exchangeRate,
      lines: lines,
    );

    await ledgerPostingService.postJournal(
      journalId: journalId,
      date: entry.date,
      currency: currency,
    );

    return journalId;
  }
}
