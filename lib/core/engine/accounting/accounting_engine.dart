import 'package:get_it/get_it.dart';
import '../../errors/result.dart';
import '../../errors/app_exception.dart';
import '../../event_bus/event_bus.dart';
import '../../services/transaction_manager.dart';
import '../../services/numbering/number_generator.dart';
import '../../repositories/journal_repository.dart';
import '../../repositories/ledger_repository.dart';
import 'transaction_context.dart';
import 'transaction_result.dart';
import '../validation/transaction_validator.dart';
import '../workflow/workflow_engine.dart';

class AccountingEngine {
  final TransactionValidator _validator;
  final WorkflowEngine _workflow;
  final NumberGenerator _numberGenerator;
  final TransactionManager _transactionManager;
  final AppEventBus _eventBus;
  final JournalRepository _journalRepo;
  final LedgerRepository _ledgerRepo;

  AccountingEngine({
    required TransactionValidator validator,
    required WorkflowEngine workflow,
    required NumberGenerator numberGenerator,
    required TransactionManager transactionManager,
    required AppEventBus eventBus,
    required JournalRepository journalRepo,
    required LedgerRepository ledgerRepo,
  }) : _validator = validator,
       _workflow = workflow,
       _numberGenerator = numberGenerator,
       _transactionManager = transactionManager,
       _eventBus = eventBus,
       _journalRepo = journalRepo,
       _ledgerRepo = ledgerRepo;

  Future<Result<TransactionResult>> execute(
    TransactionContext context, {
    TransactionStatus initialStatus = TransactionStatus.approved,
  }) async {
    final validationResult = _validator.validate(context);
    if (!validationResult.isValid) {
      return Failure(ValidationException(validationResult.errors.join('، ')));
    }

    final status = _workflow.execute(initialStatus, WorkflowAction.post);
    if (status != TransactionStatus.posted) {
      return Failure(
        const AppException('لا يمكن ترحيل العملية في حالتها الحالية'),
      );
    }

    final number = await _numberGenerator.generate(
      context.type.name,
      date: context.date,
    );

    return _transactionManager.execute<TransactionResult>(
      operation: () async {
        // 1. حفظ القيد في JournalEntries + JournalLines
        final entryId = await _journalRepo.saveJournalEntry(
          entryNumber: number,
          entryDate: context.date,
          operationType: context.type.name,
          description: context.reference,
          referenceType: context.type.name,
          referenceId: context.reference,
          currencyCode: context.currencyCode ?? 'YER',
          exchangeRate: context.exchangeRate,
          lines: context.items
              .map(
                (item) => {
                  'accountId': item.accountId,
                  'debit': item.debit,
                  'credit': item.credit,
                  'description': item.description,
                },
              )
              .toList(),
        );

        // 2. تحديث Ledger لكل بند
        final lines = await _journalRepo.getEntryLines(entryId);
        for (final line in lines) {
          await _ledgerRepo.addLedgerEntry(
            journalEntryId: entryId,
            journalLineId: line['id'] as int,
            accountId: line['account_id'] as int,
            entryDate: context.date,
            debit: double.tryParse(line['debit']?.toString() ?? '0') ?? 0,
            credit: double.tryParse(line['credit']?.toString() ?? '0') ?? 0,
            currencyCode: context.currencyCode ?? 'YER',
          );
        }

        _eventBus.fire(
          TransactionCompleted({'entryId': entryId, 'number': number}),
        );
        return TransactionResult.success(number);
      },
      action: 'POST_${context.type.name.toUpperCase()}',
      entityType: 'Transaction',
      entityId: number,
      description: context.reference ?? 'عملية محاسبية',
    );
  }

  Future<Result<TransactionResult>> saveAsDraft(
    TransactionContext context,
  ) async {
    final validationResult = _validator.validate(context);
    if (!validationResult.isValid) {
      return Failure(const ValidationException('Validation failed'));
    }

    return _transactionManager.execute<TransactionResult>(
      operation: () async => TransactionResult.draft(),
      action: 'DRAFT_${context.type.name.toUpperCase()}',
      entityType: 'Transaction',
      description: context.reference ?? 'مسودة عملية',
    );
  }
}

extension AccountingEngineLocator on GetIt {
  AccountingEngine get accountingEngine => this<AccountingEngine>();
}
