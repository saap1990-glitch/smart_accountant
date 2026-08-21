enum UserIntent {
  createSale,
  createPurchase,
  createReceipt,
  createPayment,
  createJournal,
  createCustomer,
  createSupplier,
  createItem,
  queryBalance,
  queryReport,
  queryAccount,
  queryInventory,
  sendDocument,
  help,
  unknown,
}

class DetectedIntent {

  DetectedIntent({
    required this.intent,
    this.entities = const {},
    this.confidence = 0.0,
    this.followUpQuestion,
  });
  final UserIntent intent;
  final Map<String, dynamic> entities;
  final double confidence;
  final String? followUpQuestion;
}

class IntentAnalyzer {
  static final Map<String, UserIntent> _patterns = {
    'بيع': UserIntent.createSale,
    'فاتورة بيع': UserIntent.createSale,
    'شراء': UserIntent.createPurchase,
    'فاتورة شراء': UserIntent.createPurchase,
    'قبض': UserIntent.createReceipt,
    'سند قبض': UserIntent.createReceipt,
    'صرف': UserIntent.createPayment,
    'سند صرف': UserIntent.createPayment,
    'قيد': UserIntent.createJournal,
    'عميل': UserIntent.createCustomer,
    'مورد': UserIntent.createSupplier,
    'صنف': UserIntent.createItem,
    'رصيد': UserIntent.queryBalance,
    'كشف': UserIntent.queryReport,
    'تقرير': UserIntent.queryReport,
    'أرباح': UserIntent.queryReport,
    'مخزون': UserIntent.queryInventory,
    'حركة': UserIntent.queryInventory,
    'أرسل': UserIntent.sendDocument,
    'واتساب': UserIntent.sendDocument,
    'كيف': UserIntent.help,
    'شرح': UserIntent.help,
  };

  DetectedIntent analyze(String text) {
    final lower = text.toLowerCase().trim();
    UserIntent bestMatch = UserIntent.unknown;
    double bestConfidence = 0.0;

    for (var entry in _patterns.entries) {
      if (lower.contains(entry.key.toLowerCase())) {
        bestMatch = entry.value;
        bestConfidence = 0.8;
        break;
      }
    }

    final entities = <String, dynamic>{};
    
    // استخراج المبالغ
    final amountRegex = RegExp(r'(\d+(?:,\d{3})*(?:\.\d+)?)\s*(?:ريال|دولار|يورو)?');
    final amountMatch = amountRegex.firstMatch(text);
    if (amountMatch != null) {
      entities['amount'] = double.tryParse(amountMatch.group(1)!.replaceAll(',', ''));
    }

    // استخراج الكميات
    final qtyRegex = RegExp(r'(\d+)\s*(?:كيس|كرتون|قطعة|حبة|علبة)');
    final qtyMatch = qtyRegex.firstMatch(text);
    if (qtyMatch != null) {
      entities['quantity'] = int.tryParse(qtyMatch.group(1)!);
    }

    String? followUp;
    if (bestMatch == UserIntent.unknown) {
      followUp = 'عذراً، لم أفهم طلبك. هل يمكنك توضيح ما تريد فعله؟\n'
          'مثلاً: "أنشئ فاتورة بيع" أو "كم رصيد الصندوق؟"';
    } else if (bestConfidence < 0.9) {
      followUp = 'هل يمكنك إعطائي تفاصيل أكثر؟';
    }

    return DetectedIntent(
      intent: bestMatch,
      entities: entities,
      confidence: bestConfidence,
      followUpQuestion: followUp,
    );
  }
}
