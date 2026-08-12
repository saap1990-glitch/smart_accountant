import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../core/services/ai/ai_service.dart';
import '../../core/services/ai/agent/conversation_memory.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _aiService = GetIt.I<AiService>();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _aiService.memory.addAssistantMessage(
      'مرحباً! 👋 أنا مساعدك المحاسبي الذكي.\n'
      'يمكنني مساعدتك في:\n'
      '📝 إنشاء الفواتير والسندات\n'
      '📊 عرض التقارير والأرباح\n'
      '🔍 الاستعلام عن الأرصدة\n'
      '📤 إرسال المستندات\n\n'
      'جرب أن تقول: "أنشئ فاتورة بيع بمبلغ 5000 ريال"',
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _isProcessing) return;
    _textController.clear();
    _processCommand(text);
  }

  Future<void> _processCommand(String command) async {
    setState(() => _isProcessing = true);
    final reply = await _aiService.processCommand(command);
    setState(() => _isProcessing = false);
    _scrollToBottom();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الميكروفون غير متاح')),
      );
      return;
    }
    setState(() => _isListening = true);
    _speech.listen(
      onResult: (result) {
        setState(() {
          _textController.text = result.recognizedWords;
          _isListening = false;
        });
        if (result.recognizedWords.isNotEmpty) {
          _sendMessage(result.recognizedWords);
        }
      },
      localeId: 'ar',
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = _aiService.history;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.auto_awesome, size: 18, color: Colors.white),
            ),
            SizedBox(width: 8),
            Text('المساعد الذكي'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'مسح المحادثة',
            onPressed: () {
              _aiService.memory.clear();
              _aiService.memory.addAssistantMessage('تم مسح المحادثة. كيف يمكنني مساعدتك؟');
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // منطقة المحادثة
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length + (_isProcessing ? 1 : 0),
                    itemBuilder: (ctx, index) {
                      // مؤشر التحميل
                      if (_isProcessing && index == messages.length) {
                        return _buildTypingIndicator();
                      }
                      final msg = messages[index];
                      final isUser = msg.role == 'user';
                      return _buildMessageBubble(msg, isUser, theme);
                    },
                  ),
          ),

          // الاقتراحات
          if (messages.length <= 2 && !_isProcessing)
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _aiService.suggestions.take(4).length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final s = _aiService.suggestions[i];
                  return ActionChip(
                    label: Text(s, style: const TextStyle(fontSize: 12)),
                    avatar: const Icon(Icons.lightbulb, size: 16),
                    onPressed: () => _sendMessage(s),
                  );
                },
              ),
            ),

          // شريط الإدخال
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // زر الميكروفون
                  GestureDetector(
                    onLongPress: _startListening,
                    onLongPressUp: _stopListening,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isListening ? Colors.red : Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // حقل النص
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      enabled: !_isProcessing,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // زر الإرسال
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: _isProcessing
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _isProcessing ? null : () => _sendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.teal, Color(0xFF4ED9B2)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.auto_awesome, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text('مساعدك المحاسبي الذكي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('اسأل أي شيء عن حساباتك', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ConversationMessage msg, bool isUser, ThemeData theme) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal : theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(18),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('🤖 المساعد', style: TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
              ),
            Text(
              msg.content,
              style: TextStyle(fontSize: 15, color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 10, color: isUser ? Colors.white70 : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.teal, child: Icon(Icons.auto_awesome, size: 14, color: Colors.white)),
            SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: LinearProgressIndicator(backgroundColor: Color(0xFFEEEEEE)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
