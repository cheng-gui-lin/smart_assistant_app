import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _apiKey = 'sk-a06a73302fc640129cd5688436f5a0c1';
  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';

  static const String systemIdentity = '你的名字叫晴天，是一名温暖治愈、乐观开朗的生活陪伴助手。'
      '你的核心使命是陪伴用户、帮助用户管理时间、调节情绪，提供情绪价值。'
      '请遵循以下回复规则：'
      '1. 简短精炼：每句话不超过30字，避免长篇大论'
      '2. 口语化表达：像和朋友聊天一样自然，偶尔用"呀""哦""呢"等语气词，但不过度使用'
      '3. 积极正向：永远用鼓励的语气，不批评、不说教、不指责'
      '4. 有温度有共情：能感受到用户的情绪，给出真诚的回应'
      '5. 适当使用表情：每句话最多用1个表情，常用😋💪✨🥰😌'
      '6. 记住用户之前说过的话和重要信息'
      '7. 围绕用户的话题展开，不要突然转移话题用户提问时，给出简洁实用的回答'
      '8. 用户倾诉时，先倾听共情，再适当给出建议'
      '9. 可以主动关心用户，但不要过度打扰'
      '10.敏锐识别用户的情绪变化,情绪低落时，做一个安静的倾听者,焦虑时，帮用户拆解任务，降低心理负担,开心时，和用户一起分享喜悦';

  Future<String> chatText(String userMessage, {String? systemPrompt}) async {
    try {
      final messages = <Map<String, dynamic>>[];
      if (systemPrompt != null) {
        messages.add({'role': 'system', 'content': systemPrompt});
      }
      messages.add({'role': 'user', 'content': userMessage});

      final response = await http
          .post(Uri.parse(_baseUrl),
              headers: {
                'Authorization': 'Bearer $_apiKey',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'model': 'deepseek-chat',
                'messages': messages,
                'stream': false,
              }))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      }
      return _fallbackText();
    } catch (_) {
      return _fallbackText();
    }
  }

  Future<String> chatConversation(List<Map<String, String>> history) async {
    try {
      final messages = history
          .map((m) => {
                'role': m['role'] == 'ai' ? 'assistant' : m['role'],
                'content': m['content'],
              })
          .toList();

      final response = await http
          .post(Uri.parse(_baseUrl),
              headers: {
                'Authorization': 'Bearer $_apiKey',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'model': 'deepseek-chat',
                'messages': messages,
                'stream': false,
              }))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      }
      return _fallbackText();
    } catch (_) {
      return _fallbackText();
    }
  }

  Future<String> generateDailySummary(
    int completedCount,
    int totalCount,
    int focusMinutes,
    String nickname,
  ) async {
    try {
      final prompt = '为$nickname生成一段简短温暖的每日小结（50字以内）：'
          '完成了$completedCount/$totalCount个待办，专注了$focusMinutes分钟。';

      final response = await http
          .post(Uri.parse(_baseUrl),
              headers: {
                'Authorization': 'Bearer $_apiKey',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'model': 'deepseek-chat',
                'stream': false,
                'messages': [
                  {'role': 'system', 'content': systemIdentity},
                  {'role': 'user', 'content': prompt},
                ],
              }))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      }
      return _defaultSummary(
          completedCount, totalCount, focusMinutes, nickname);
    } catch (_) {
      return _defaultSummary(
          completedCount, totalCount, focusMinutes, nickname);
    }
  }

  String detectEmotion(String text) {
    if (text.contains('开心') ||
        text.contains('高兴') ||
        text.contains('棒') ||
        text.contains('充实') ||
        text.contains('成功')) {
      return '开心';
    }
    if (text.contains('焦虑') ||
        text.contains('紧张') ||
        text.contains('担心') ||
        text.contains('不安')) {
      return '焦虑';
    }
    if (text.contains('累') ||
        text.contains('疲惫') ||
        text.contains('困') ||
        text.contains('疲劳')) {
      return '疲惫';
    }
    if (text.contains('难过') ||
        text.contains('伤心') ||
        text.contains('哭') ||
        text.contains('失落')) {
      return '难过';
    }
    return '平静';
  }

  String _fallbackText() {
    return '我在听呢，可以再多说点你的想法哦😊';
  }

  String _defaultSummary(
    int completedCount,
    int totalCount,
    int focusMinutes,
    String nickname,
  ) {
    if (completedCount == totalCount && totalCount > 0) {
      return '太棒啦，全部完成！今天专注了$focusMinutes分钟，充实的一天呢✨';
    } else if (completedCount > 0) {
      return '今天完成了$completedCount个待办，专注$focusMinutes分钟，继续加油呀💪';
    }
    return '今天休息一下也很好的，明天再继续加油哦😌';
  }
}
