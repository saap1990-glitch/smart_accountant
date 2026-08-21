import '../../errors/result.dart';
import '../../di/service_locator.dart';
import '../../engine/accounting/transaction_context.dart';
import '../operations/operation_service.dart';
import '../accounting/system_account_resolver.dart';
import '../reports/report_service.dart';
import 'agent/conversation_memory.dart';
import 'agent/intent_analyzer.dart';
import 'agent/knowledge_base.dart';
import 'agent/workflow_generator.dart';

class AiService {
  AiService(this._operationService, this._reportService)
    : _memory = ConversationMemory(),
      _analyzer = IntentAnalyzer(),
      _knowledgeBase = KnowledgeBase(),
      _workflow = WorkflowGenerator();
  final OperationService _operationService;
  final ReportService _reportService;
  final ConversationMemory _memory;
  final IntentAnalyzer _analyzer;
  final KnowledgeBase _knowledgeBase;
  final WorkflowGenerator _workflow;

  List<String> get suggestions => _knowledgeBase.suggestions;
  ConversationMemory get memory => _memory;
  List<ConversationMessage> get history => _memory.history;

  Future<String> processCommand(String command) async {
    _memory.addUserMessage(command);

    // 1. تحقق من قاعدة المعرفة أولاً
    final faqAnswer = _knowledgeBase.findAnswer(command);
    if (faqAnswer != null) {
      _memory.addAssistantMessage(faqAnswer);
      return faqAnswer;
    }

    // 2. تحليل النية
    final intent = _analyzer.analyze(command);

    // 3. إذا لم يفهم، اطلب توضيحاً
    if (intent.intent == UserIntent.unknown ||
        intent.followUpQuestion != null) {
      final reply =
          intent.followUpQuestion ??
          'عذراً، لم أفهم. جرب: ${_knowledgeBase.suggestions.first}';
      _memory.addAssistantMessage(reply);
      return reply;
    }

    // 4. توليد خطة العمل

    // 5. تنفيذ العملية حسب النية
    String reply;
    switch (intent.intent) {
      case UserIntent.createSale:
        reply = await _createSale(intent);
        break;
      case UserIntent.createReceipt:
        reply = await _createReceipt(intent);
        break;
      case UserIntent.createPayment:
        reply = await _createPayment(intent);
        break;
      case UserIntent.queryBalance:
        reply = await _queryBalance(intent);
        break;
      case UserIntent.queryReport:
        reply = await _showReport(intent);
        break;
      case UserIntent.help:
        reply =
            'يمكنني مساعدتك في:\n'
            '📝 إنشاء الفواتير والسندات\n'
            '📊 عرض التقارير والأرباح\n'
            '🔍 الاستعلام عن الأرصدة\n'
            '📤 إرسال المستندات\n'
            '❓ الإجابة عن أسئلة الاستخدام\n\n'
            'جرب: "${_knowledgeBase.suggestions.first}"';
        break;
      default:
        reply =
            'جاري تطوير هذه الميزة. يمكنك تجربة: ${_knowledgeBase.suggestions.first}';
    }

    _memory.addAssistantMessage(reply);
    return reply;
  }

  Future<String> _createSale(DetectedIntent intent) async {
    final amount = (intent.entities['amount'] as double?) ?? 1000.0;
    final resolver = await sl<SystemAccountResolver>();
    final cashId = await resolver.resolve('cash_default');
    final salesId = await resolver.resolve('sales_revenue');
    final items = [
      JournalItem(accountId: cashId, debit: amount),
      JournalItem(accountId: salesId, credit: amount),
    ];

    final result = await _operationService.execute(
      type: TransactionType.sale,
      date: DateTime.now(),
      items: items,
      reference: 'فاتورة بيع (مساعد ذكي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء فاتورة البيع برقم ${res.entryNumber}\n'
            'المبلغ: ${amount.toStringAsFixed(0)} ريال\n'
            'الحالة: ${res.status.name}';
      case Failure(exception: final e):
        return '❌ فشل إنشاء الفاتورة: ${e.message}';
    }
  }

  Future<String> _createReceipt(DetectedIntent intent) async {
    final amount = (intent.entities['amount'] as double?) ?? 500.0;
    final resolver = await sl<SystemAccountResolver>();
    final cashId = await resolver.resolve('cash_default');
    final debtorsId = await resolver.resolve(
      'customer_parent',
    ); // يمكن تعديلها حسب الحاجة
    final items = [
      JournalItem(accountId: debtorsId, debit: amount),
      JournalItem(accountId: cashId, credit: amount),
    ];

    final result = await _operationService.execute(
      type: TransactionType.receipt,
      date: DateTime.now(),
      items: items,
      reference: 'سند قبض (مساعد ذكي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء سند القبض برقم ${res.entryNumber}\nالمبلغ: ${amount.toStringAsFixed(0)} ريال';
      case Failure(exception: final e):
        return '❌ فشل إنشاء سند القبض: ${e.message}';
    }
  }

  Future<String> _createPayment(DetectedIntent intent) async {
    final amount = (intent.entities['amount'] as double?) ?? 300.0;
    final resolver = await sl<SystemAccountResolver>();
    final cashId = await resolver.resolve('cash_default');
    final creditorsId = await resolver.resolve(
      'supplier_parent',
    ); // يمكن تعديلها حسب الحاجة
    final items = [
      JournalItem(accountId: creditorsId, debit: amount),
      JournalItem(accountId: cashId, credit: amount),
    ];

    final result = await _operationService.execute(
      type: TransactionType.payment,
      date: DateTime.now(),
      items: items,
      reference: 'سند صرف (مساعد ذكي)',
    );

    switch (result) {
      case Success(data: final res):
        return '✅ تم إنشاء سند الصرف برقم ${res.entryNumber}\nالمبلغ: ${amount.toStringAsFixed(0)} ريال';
      case Failure(exception: final e):
        return '❌ فشل إنشاء سند الصرف: ${e.message}';
    }
  }

  Future<String> _queryBalance(DetectedIntent intent) async {
    final report = await _reportService.balanceSheet(DateTime.now());
    return '📊 الملخص المالي:\n'
        '💰 الأصول: ${report['assets']} ريال\n'
        '📋 الخصوم: ${report['liabilities']} ريال\n'
        '📈 حقوق الملكية: ${report['equity']} ريال';
  }

  Future<String> _showReport(DetectedIntent intent) async {
    final report = await _reportService.profitReport(
      from: DateTime(DateTime.now().year, 1, 1),
      to: DateTime.now(),
    );
    return '📊 تقرير الأرباح:\n'
        '🟢 المبيعات: ${report['total_sales']} ريال\n'
        '🔴 المشتريات: ${report['total_purchases']} ريال\n'
        '💎 مجمل الربح: ${report['gross_profit']} ريال\n'
        '⭐ صافي الربح: ${report['net_profit']} ريال';
  }
}

// Extension للصوت
extension AiServiceVoice on AiService {
  Future<String> processVoiceCommand(String recognizedText) async {
    return processCommand(recognizedText);
  }
}
