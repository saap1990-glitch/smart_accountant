import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class TransferBankScreen extends StatelessWidget {
  const TransferBankScreen({super.key});

  @override
  Widget build(BuildContext context) => const SmartOperationForm(
    config: OperationConfig(
      title: 'تحويل بنكي',
      transactionType: TransactionType.transfer,
      showBankSource: true,
      showDebitAccount: true,
      showCreditAccount: true,
    ),
  );
}
