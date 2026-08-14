import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class InventoryOutScreen extends StatelessWidget {
  const InventoryOutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'صرف مخزني',
        transactionType: TransactionType.transfer,
        showWarehouse: true,
        showDebitAccount: true,
        showItems: true,
        showPrice: false,
        showFreeQty: false,
        isInventoryOut: true,
      ),
    );
  }
}
