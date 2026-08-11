import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class TransferBankScreen extends StatelessWidget {
  const TransferBankScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'تحويل بين البنوك',
        transactionType: TransactionType.transfer,
        amountLabel: 'المبلغ المحول',
        showCashSource: true,
        showDestination: true,
      ),
    );
  }
}
