class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.lastMessagePreview,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String lastMessagePreview;
  final DateTime updatedAt;
}

class ConversationMessage {
  const ConversationMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String role;
  final String text;
  final DateTime createdAt;
}
