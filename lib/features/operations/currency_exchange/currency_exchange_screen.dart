import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/operations/operation_service.dart';
import '../../../core/engine/accounting/transaction_context.dart';
import '../shared/transaction_form.dart';

class CurrencyExchangeScreen extends StatelessWidget {
  const CurrencyExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = GetIt.I<OperationService>();
    return TransactionForm(
      title: 'تحويل عملات',
      transactionType: TransactionType.transfer,
      operationService: service,
      amountLabel: 'المبلغ المحول',
      sourceLabel: 'من عملة',
      sourceTypes: const ['عملة'],
      debitAccountPrefix: null,
      creditAccountPrefix: null,
      showCurrencyExchange: true,
    );
  }
}
