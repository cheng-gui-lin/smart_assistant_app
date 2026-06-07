import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_harmonyos/models/post.dart';
import 'package:flutter_harmonyos/models/chat_session.dart';
import 'package:flutter_harmonyos/services/deepseek_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LifeProvider extends ChangeNotifier {
  List<Post> _posts = [];
  ChatSession _chatSession = ChatSession(id: 'default', title: 'AI小助手');

  final DeepSeekService _deepSeek = DeepSeekService();

  List<Post> get posts {
    _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _posts;
  }

  ChatSession get chatSession => _chatSession;

  LifeProvider() {
    _loadFromHive();
  }

  void _loadFromHive() {
    final postsBox = Hive.box('posts');
    final postsData = postsBox.get('data') as String?;
    if (postsData != null) {
      final list = jsonDecode(postsData) as List<dynamic>;
      _posts =
          list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      _initMockPosts();
    }

    final chatBox = Hive.box('chat_sessions');
    final chatData = chatBox.get('data') as String?;
    if (chatData != null) {
      _chatSession =
          ChatSession.fromJson(jsonDecode(chatData) as Map<String, dynamic>);
    } else {
      _initMockChat();
    }
  }

  void _savePostsToHive() {
    final box = Hive.box('posts');
    box.put('data', jsonEncode(_posts.map((p) => p.toJson()).toList()));
  }

  void _saveChatToHive() {
    final box = Hive.box('chat_sessions');
    box.put('data', jsonEncode(_chatSession.toJson()));
  }

  void _initMockPosts() {
    final now = DateTime.now();
    _posts = [
      Post(
        id: 'p1',
        content: '今天图书馆学了6小时，感觉很充实！',
        moodEmoji: '😊',
        moodLabel: '开心',
        createdAt: DateTime(now.year, now.month, now.day, 16, 30),
        replies: [
          ChatMessage(
              role: 'ai',
              content: '太棒啦，学6小时真厉害！今天收获满满呢💪',
              timestamp: DateTime(now.year, now.month, now.day, 16, 30, 5)),
        ],
      ),
      Post(
        id: 'p2',
        content: '好焦虑，复习不完...感觉时间完全不够用',
        moodEmoji: '😰',
        moodLabel: '焦虑',
        createdAt: DateTime(now.year, now.month, now.day - 1, 22, 15),
        replies: [
          ChatMessage(
              role: 'ai',
              content: '别急哦，一步步来就好。先做最重要的，你比想象中更棒✨',
              timestamp: DateTime(now.year, now.month, now.day - 1, 22, 15, 5)),
        ],
      ),
      Post(
        id: 'p3',
        content: '想家了...好想吃妈妈做的饭',
        moodEmoji: '😢',
        moodLabel: '难过',
        createdAt: DateTime(now.year, now.month, now.day - 2, 10, 15),
        replies: [
          ChatMessage(
              role: 'ai',
              content: '抱抱你呀� 想家就给家人打个视频吧，他们一定也很想你',
              timestamp: DateTime(now.year, now.month, now.day - 2, 10, 15, 5)),
        ],
      ),
    ];
  }

  void _initMockChat() {
    _chatSession = ChatSession(
      id: 'default',
      title: 'AI小助手',
      messages: [
        ChatMessage(role: 'ai', content: '你好呀！我是晴天，你的大学陪伴助手。有什么想聊聊的吗😊'),
      ],
    );
  }

  Future<void> addPost(
    String content,
    String moodEmoji,
    String moodLabel, {
    String? base64Image,
  }) async {
    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      moodEmoji: moodEmoji,
      moodLabel: moodLabel,
      imageBase64: base64Image,
    );
    _posts.add(post);
    _savePostsToHive();
    notifyListeners();

    final displayContent = content.isNotEmpty ? content : '用户分享了一条动态';
    final aiResult = await _deepSeek.chatText(
      displayContent,
      systemPrompt:
          '${DeepSeekService.systemIdentity}\n用户发布了一条动态，心情是$moodLabel。请基于内容给出20-40字的温暖鼓励或共情点评。',
    );

    post.replies.add(ChatMessage(role: 'ai', content: aiResult));
    _savePostsToHive();
    notifyListeners();
  }

  Future<void> replyToPost(String postId, String text) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.replies.add(ChatMessage(role: 'user', content: text));
    _savePostsToHive();
    notifyListeners();

    final history = <Map<String, String>>[];
    history.add({
      'role': 'system',
      'content':
          '${DeepSeekService.systemIdentity}\n用户发了一条动态，心情是${post.moodLabel}。现在用户想继续聊聊这条动态，请以温暖共情的语气简短回复。',
    });
    history.add({
      'role': 'user',
      'content': post.content.isNotEmpty ? post.content : '用户分享了一条动态',
    });
    for (final msg in post.replies) {
      history.add({
        'role': msg.role,
        'content': msg.content,
      });
    }

    final response = await _deepSeek.chatConversation(history);

    post.replies.add(ChatMessage(role: 'ai', content: response));
    _savePostsToHive();
    notifyListeners();
  }

  Future<void> sendToAI(String text) async {
    _chatSession.messages.add(ChatMessage(role: 'user', content: text));
    _saveChatToHive();
    notifyListeners();

    final recentMessages = _chatSession.messages.length > 40
        ? _chatSession.messages.sublist(_chatSession.messages.length - 40)
        : _chatSession.messages;
    final history = <Map<String, String>>[];
    history.add({
      'role': 'system',
      'content': DeepSeekService.systemIdentity,
    });
    for (final msg in recentMessages) {
      history.add({
        'role': msg.role,
        'content': msg.content,
      });
    }

    final response = await _deepSeek.chatConversation(history);

    _chatSession.messages.add(ChatMessage(role: 'ai', content: response));
    // 限制消息数量不超过 200 条
    if (_chatSession.messages.length > 200) {
      _chatSession.messages =
          _chatSession.messages.sublist(_chatSession.messages.length - 200);
    }
    _saveChatToHive();
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((p) => p.id == id);
    _savePostsToHive();
    notifyListeners();
  }

  Post? getPostById(String id) {
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
