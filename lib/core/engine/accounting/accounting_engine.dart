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

  AccountingEngine({
    required this._validator,
    required this._workflow,
    required this._numberGenerator,
    required this._transactionManager,
    required this._eventBus,
    required this._journalRepo,
    required this._ledgerRepo,
  });
  final TransactionValidator _validator;
  final WorkflowEngine _workflow;
  final NumberGenerator _numberGenerator;
  final TransactionManager _transactionManager;
  final AppEventBus _eventBus;
  final JournalRepository _journalRepo;
  final LedgerRepository _ledgerRepo;

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
      return const Failure(
        AppException('لا يمكن ترحيل العملية في حالتها الحالية'),
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
      return const Failure(ValidationException('Validation failed'));
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
