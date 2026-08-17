import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class TransferCashScreen extends StatelessWidget {
  const TransferCashScreen({super.key});

  @override
  Widget build(BuildContext context) => const SmartOperationForm(
    config: OperationConfig(
      title: 'تحويل نقدي بين الخزائن',
      transactionType: TransactionType.transfer,
      showCashSource: true,
      showDebitAccount: true,
      showCreditAccount: true,
    ),
  );
}
