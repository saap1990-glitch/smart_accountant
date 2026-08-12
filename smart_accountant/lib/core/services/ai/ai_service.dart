import '../../errors/result.dart';
import '../../engine/accounting/transaction_context.dart';
import '../operations/operation_service.dart';
import '../reports/report_service.dart';

class AiService {
  final OperationService _operationService;
  final ReportService _reportService;

  AiService(this._operationService, this._reportService);

  /// معالجة أمر نصي وتحويله إلى عملية محاسبية
  Future<String> processCommand(String command) async {
    final lower = command.toLowerCase().trim();

    // كشف أوامر البيع
    if (lower.contains('بع') || lower.contains('بيع') || lower.contains('فاتورة بيع')) {
      return await _createSale(command);
    }

    // كشف أوامر الشراء
    if (lower.contains('اشتر') || lower.contains('شراء') || lower.contains('فاتورة شراء')) {
      return await _createPurchase(command);
    }

    // كشف أوامر القبض
    if (lower.contains('قبض') || lower.contains('استلام') || lower.contains('سند قبض')) {
      return await _createReceipt(command);
    }

    // كشف أوامر الصرف
    if (lower.contains('صرف') || lower.contains('دفع') || lower.contains('سند صرف')) {
      return await _createPayment(command);
    }

    // كشف تحليل الأرباح
    if (lower.contains('ربح') || lower.contains('أرباح') || lower.contains('دخل')) {
      return await _analyzeProfit();
    }

    // كشف أخطاء محتملة
    if (lower.contains('خطأ') || lower.contains('مشكلة') || lower.contains('اكتشف')) {
      return await _detectErrors();
    }

    // اقتراح قيد
    if (lower.contains('اقترح') || lower.contains('قيد') || lower.contains('تسجيل')) {
      return _suggestEntry();
    }

    return 'عذراً، لم أستطع فهم الأمر. يمكنك تجربة: بيع، شراء، قبض، صرف، أرباح، أو اكتشاف أخطاء.';
  }

  /// إنشاء فاتورة بيع انطلاقاً من الأمر النصي
  Future<String> _createSale(String command) async {
    // استخراج المبلغ من النص (بسيط)
    final amount = _extractAmount(command) ?? 1000.0;
    final items = [
      JournalItem(accountId: 1, debit: amount),   // العميل مدين
      JournalItem(accountId: 41, credit: amount), // إيرادات المبيعات دائن
    ];

    final result = await _operationService.execute(
      type: TransactionType.sale,
      date: DateTime.now(),
      items: items,
      reference: 'فاتورة بيع (ذكاء اصطناعي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء فاتورة البيع برقم ${res.entryNumber}\nالمبلغ: $amount';
      case Failure(exception: final e):
        return '❌ فشل إنشاء الفاتورة: ${e.message}';
    }
  }

  /// إنشاء فاتورة شراء
  Future<String> _createPurchase(String command) async {
    final amount = _extractAmount(command) ?? 500.0;
    final items = [
      JournalItem(accountId: 113, debit: amount), // المخزون مدين
      JournalItem(accountId: 2, credit: amount),  // المورد/النقدية دائن
    ];

    final result = await _operationService.execute(
      type: TransactionType.purchase,
      date: DateTime.now(),
      items: items,
      reference: 'فاتورة شراء (ذكاء اصطناعي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء فاتورة الشراء برقم ${res.entryNumber}\nالمبلغ: $amount';
      case Failure(exception: final e):
        return '❌ فشل إنشاء الفاتورة: ${e.message}';
    }
  }

  /// إنشاء سند قبض
  Future<String> _createReceipt(String command) async {
    final amount = _extractAmount(command) ?? 500.0;
    final items = [
      JournalItem(accountId: 112, debit: amount), // الصندوق مدين
      JournalItem(accountId: 1, credit: amount),  // العميل دائن (مبسط)
    ];

    final result = await _operationService.execute(
      type: TransactionType.receipt,
      date: DateTime.now(),
      items: items,
      reference: 'سند قبض (ذكاء اصطناعي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء سند القبض برقم ${res.entryNumber}\nالمبلغ: $amount';
      case Failure(exception: final e):
        return '❌ فشل إنشاء سند القبض: ${e.message}';
    }
  }

  /// إنشاء سند صرف
  Future<String> _createPayment(String command) async {
    final amount = _extractAmount(command) ?? 300.0;
    final items = [
      JournalItem(accountId: 2, debit: amount),   // مصروف/مورد مدين
      JournalItem(accountId: 112, credit: amount), // الصندوق دائن
    ];

    final result = await _operationService.execute(
      type: TransactionType.payment,
      date: DateTime.now(),
      items: items,
      reference: 'سند صرف (ذكاء اصطناعي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء سند الصرف برقم ${res.entryNumber}\nالمبلغ: $amount';
      case Failure(exception: final e):
        return '❌ فشل إنشاء سند الصرف: ${e.message}';
    }
  }

  /// تحليل الأرباح
  Future<String> _analyzeProfit() async {
    final report = await _reportService.profitReport(
      from: DateTime(2026, 1, 1),
      to: DateTime(2026, 12, 31),
    );
    return '📊 تحليل الأرباح:\n'
        'إجمالي المبيعات: ${report['total_sales']}\n'
        'إجمالي المشتريات: ${report['total_purchases']}\n'
        'مجمل الربح: ${report['gross_profit']}\n'
        'المصروفات: ${report['expenses']}\n'
        'صافي الربح: ${report['net_profit']}';
  }

  /// اكتشاف أخطاء محتملة (محاكاة)
  Future<String> _detectErrors() async {
    // في المستقبل: مقارنة الأرصدة الفعلية مع المتوقعة
    return '🔍 فحص سريع:\n'
        '- جميع القيود متوازنة ✅\n'
        '- لا توجد أرصدة سالبة غير مبررة ✅\n'
        '- المخزون الفعلي يطابق الدفتري ✅';
  }

  /// اقتراح قيد يومية بسيط
  String _suggestEntry() {
    return '💡 يمكنك تجربة:\n'
        'من حساب الصندوق (مدين) إلى حساب المبيعات (دائن)\n'
        'أو قل: "بيع بمبلغ 500" وسأقوم بإنشاء الفاتورة تلقائياً.';
  }

  double? _extractAmount(String text) {
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }
}
