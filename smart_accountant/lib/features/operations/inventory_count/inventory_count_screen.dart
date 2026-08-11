import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../../core/engine/accounting/transaction_context.dart';

class InventoryCountScreen extends StatelessWidget {
  const InventoryCountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartOperationForm(
      config: const OperationConfig(
        title: 'جرد المخزون',
        transactionType: TransactionType.inventory,
        showItems: true,
        isInventory: true,
      ),
    );
  }
}
