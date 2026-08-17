import 'package:flutter/material.dart';
import '../shared/smart_operation_form.dart';
import '../../../core/engine/accounting/transaction_context.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SmartOperationForm(
      config: OperationConfig(
        title: 'فاتورة بيع',
        transactionType: TransactionType.sale,
        showPaymentMode: true,
        showCustomer: true,
        showCashSource: true,
        showBankSource: true,
        showCreditAccount: true,
        showWarehouse: true,
        showItems: true,
        showInvoiceNumber: true,
        showPrice: true,
        showFreeQty: true,
      ),
    );
  }
}
