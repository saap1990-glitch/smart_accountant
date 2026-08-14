class ConversationMessage {
  final String role; // user, assistant, system
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ConversationMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.metadata,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ConversationMemory {
  final List<ConversationMessage> _messages = [];
  static const int maxMessages = 20;

  List<ConversationMessage> get history => List.unmodifiable(_messages);
  List<ConversationMessage> get recentContext {
    if (_messages.length <= 6) return history;
    return _messages.sublist(_messages.length - 6);
  }

  void addUserMessage(String content, {Map<String, dynamic>? metadata}) {
    _messages.add(ConversationMessage(role: 'user', content: content, metadata: metadata));
    _trim();
  }

  void addAssistantMessage(String content, {Map<String, dynamic>? metadata}) {
    _messages.add(ConversationMessage(role: 'assistant', content: content, metadata: metadata));
    _trim();
  }

  void addSystemMessage(String content) {
    _messages.add(ConversationMessage(role: 'system', content: content));
    _trim();
  }

  void _trim() {
    while (_messages.length > maxMessages) {
      _messages.removeAt(0);
    }
  }

  String get contextSummary {
    return recentContext.map((m) => '${m.role}: ${m.content}').join('\n');
  }

  void clear() => _messages.clear();
}
