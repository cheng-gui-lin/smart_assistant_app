class ChatMessage {
  final String role;
  String content;
  String? imagePath;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    this.imagePath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        'imagePath': imagePath,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: json['role'] as String,
        content: json['content'] as String,
        imagePath: json['imagePath'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class ChatSession {
  final String id;
  String title;
  final DateTime createdAt;
  List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    DateTime? createdAt,
    List<ChatMessage>? messages,
  })  : createdAt = createdAt ?? DateTime.now(),
        messages = messages ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        messages: (json['messages'] as List<dynamic>?)
                ?.map(
                    (m) => ChatMessage.fromJson(m as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
