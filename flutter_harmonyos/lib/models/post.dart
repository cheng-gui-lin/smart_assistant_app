import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_harmonyos/models/chat_session.dart';

class Post {
  final String id;
  String content;
  String moodEmoji;
  String moodLabel;
  String? imageBase64;
  final DateTime createdAt;
  List<ChatMessage> replies;

  Post({
    required this.id,
    required this.content,
    required this.moodEmoji,
    required this.moodLabel,
    this.imageBase64,
    DateTime? createdAt,
    List<ChatMessage>? replies,
  })  : createdAt = createdAt ?? DateTime.now(),
        replies = replies ?? [];

  Uint8List? get imageBytes =>
      imageBase64 != null ? base64Decode(imageBase64!) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'moodEmoji': moodEmoji,
        'moodLabel': moodLabel,
        'imageBase64': imageBase64,
        'createdAt': createdAt.toIso8601String(),
        'replies': replies.map((r) => r.toJson()).toList(),
      };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as String,
        content: json['content'] as String,
        moodEmoji: json['moodEmoji'] as String,
        moodLabel: json['moodLabel'] as String,
        imageBase64: json['imageBase64'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        replies: (json['replies'] as List<dynamic>?)
                ?.map((r) => ChatMessage.fromJson(r as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
