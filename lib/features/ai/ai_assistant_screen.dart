import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/ai/ai_service.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _aiService = GetIt.I<AiService>();

  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isProcessing = false;
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addMessage(
      'assistant',
      'مرحباً! أنا مساعدك المحاسبي. جرب:\n• "أنشئ فاتورة بيع بمبلغ 5000"\n• "اعرض تقرير الأرباح"\n• "كم رصيد الصندوق؟"',
    );
  }

  void _addMessage(String role, String content) {
    setState(() => _messages.add({'role': role, 'text': content}));
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients)
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
    return _aiService.processCommand(command);
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
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textCtrl,
                    decoration: const InputDecoration(
                      hintText: 'اكتب أمراً...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _send,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _send(_textCtrl.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
