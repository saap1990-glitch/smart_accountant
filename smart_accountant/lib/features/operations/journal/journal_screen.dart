import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'قيد يومية',
        transactionType: TransactionType.journal,
        amountLabel: 'المبلغ',
        showMultiLines: true,
      ),
    );
  }
}
