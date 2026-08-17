import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class TransferWalletScreen extends StatelessWidget {
  const TransferWalletScreen({super.key});

  @override
  Widget build(BuildContext context) => const SmartOperationForm(
    config: OperationConfig(
      title: 'تحويل بين المحافظ',
      transactionType: TransactionType.transfer,
      showDebitAccount: true,
      showCreditAccount: true,
    ),
  );
}
