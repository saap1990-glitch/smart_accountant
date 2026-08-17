import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class InventoryInScreen extends StatelessWidget {
  const InventoryInScreen({super.key});

  @override
  Widget build(BuildContext context) => const SmartOperationForm(
    config: OperationConfig(
      title: 'توريد مخزني',
      transactionType: TransactionType.transfer,
      showWarehouse: true,
      showItems: true,
      showCreditAccount: true,
      showPrice: false,
      showFreeQty: false,
      isInventoryIn: true,
    ),
  );
}
