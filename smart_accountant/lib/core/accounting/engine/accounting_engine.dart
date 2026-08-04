import '../models/accounting_entry.dart';
import '../validation/accounting_validator.dart';
import '../results/accounting_result.dart';

class AccountingEngine {
  final AccountingValidator validator;

  const AccountingEngine({required this.validator});

  Future<AccountingResult<AccountingEntry>> process(
    AccountingEntry entry,
  ) async {
    final validation = validator.validate(entry);

    if (!validation.isValid) {
      return AccountingResult.failure(validation.errors.join('\n'));
    }

    return AccountingResult.success(entry);
  }
}
