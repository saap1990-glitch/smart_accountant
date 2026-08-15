import '../../core/errors/result.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/ai/ai_service.dart';
import '../../core/services/operations/operation_service.dart';
import '../../core/services/reports/report_service.dart';
import '../../core/engine/accounting/transaction_context.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _aiService = GetIt.I<AiService>();
  final _opService = GetIt.I<OperationService>();
  final _reportService = GetIt.I<ReportService>();

  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isProcessing = false;
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addMessage('assistant', 'مرحباً! أنا مساعدك المحاسبي. جرب:\n• "أنشئ فاتورة بيع بمبلغ 5000"\n• "اعرض تقرير الأرباح"\n• "كم رصيد الصندوق؟"');
  }

  void _addMessage(String role, String content) {
    setState(() => _messages.add({'role': role, 'text': content}));
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _isProcessing) return;
    _addMessage('user', text);
    _textCtrl.clear();
    setState(() => _isProcessing = true);

    final reply = await _processCommand(text);

    _addMessage('assistant', reply);
    setState(() => _isProcessing = false);
  }

  Future<String> _processCommand(String command) async {
    final lower = command.toLowerCase().trim();

    // تقارير
    if (lower.contains('رصيد') || lower.contains('الرصيد')) {
      final balance = await _reportService.balanceSheet(DateTime.now());
      return '📊 الأصول: ${balance['assets']}\n📋 الخصوم: ${balance['liabilities']}\n💎 حقوق الملكية: ${balance['equity']}';
    }
    if (lower.contains('ربح') || lower.contains('أرباح') || lower.contains('دخل')) {
      final profit = await _reportService.profitReport(from: DateTime(DateTime.now().year, 1, 1), to: DateTime.now());
      return '💰 المبيعات: ${profit['total_sales']}\n📦 المشتريات: ${profit['total_purchases']}\n⭐ صافي الربح: ${profit['net_profit']}';
    }

    // عمليات
    if (lower.contains('بيع') || lower.contains('فاتورة')) {
      final amount = _extractAmount(command) ?? 1000;
      final items = [JournalItem(accountId: 1, debit: amount), JournalItem(accountId: 2, credit: amount)];
      final result = await _opService.execute(type: TransactionType.sale, date: DateTime.now(), items: items, reference: 'فاتورة (ذكاء اصطناعي)');
      return result is Success ? '✅ تم إنشاء الفاتورة برقم ${(result as Success).data}' : '❌ ${(result as Failure).exception.message}';
    }
    if (lower.contains('قبض')) {
      final amount = _extractAmount(command) ?? 500;
      final items = [JournalItem(accountId: 1, debit: amount), JournalItem(accountId: 2, credit: amount)];
      final result = await _opService.execute(type: TransactionType.receipt, date: DateTime.now(), items: items, reference: 'سند قبض (ذكاء اصطناعي)');
      return result is Success ? '✅ تم إنشاء السند' : '❌ ${(result as Failure).exception.message}';
    }
    if (lower.contains('صرف') || lower.contains('دفع')) {
      final amount = _extractAmount(command) ?? 300;
      final items = [JournalItem(accountId: 1, debit: amount), JournalItem(accountId: 2, credit: amount)];
      final result = await _opService.execute(type: TransactionType.payment, date: DateTime.now(), items: items, reference: 'سند صرف (ذكاء اصطناعي)');
      return result is Success ? '✅ تم إنشاء السند' : '❌ ${(result as Failure).exception.message}';
    }

    return '❓ لم أفهم طلبك. جرب:\n• "أنشئ فاتورة بيع بمبلغ 5000"\n• "اعرض تقرير الأرباح"\n• "كم رصيد الصندوق؟"';
  }

  double? _extractAmount(String text) {
    final match = RegExp(r'(\d+)').firstMatch(text);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المساعد الذكي')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isProcessing ? 1 : 0),
              itemBuilder: (ctx, index) {
                if (_isProcessing && index == _messages.length) {
                  return const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()));
                }
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(color: isUser ? Colors.teal : Colors.grey.shade200, borderRadius: BorderRadius.circular(14)),
                    child: Text(msg['text']!, style: TextStyle(fontSize: 15, color: isUser ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(child: TextField(controller: _textCtrl, decoration: const InputDecoration(hintText: 'اكتب أمراً...', border: OutlineInputBorder()), onSubmitted: _send)),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.send, color: Colors.teal), onPressed: () => _send(_textCtrl.text)),
            ]),
          ),
        ],
      ),
    );
  }
}
