import 'package:flutter/material.dart';
import 'package:flutter_harmonyos/routes/app_routes.dart';

class LifePage extends StatelessWidget {
  const LifePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('💝 生活'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            tabs: const [
              Tab(text: '动态'),
              Tab(text: 'AI小助手'),
            ],
            labelColor: const Color(0xFFF98C53),
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: const Color(0xFFF98C53),
            indicatorWeight: 3,
          ),
        ),
        body: const TabBarView(
          children: [
            _FeedTab(),
            _AIChatTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.postForm),
          backgroundColor: const Color(0xFFF98C53),
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.edit_rounded, size: 24),
        ),
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();

  final List<Map<String, dynamic>> _posts = const [
    {
      'mood': '😊',
      'moodLabel': '开心',
      'content': '今天图书馆学了6小时，感觉很充实！',
      'time': '今天 16:30',
      'aiComment': '太棒了！保持这个节奏，你一定可以达成目标的 💪',
    },
    {
      'mood': '😰',
      'moodLabel': '焦虑',
      'content': '好焦虑，复习不完...感觉时间完全不够用',
      'time': '昨天 22:15',
      'aiComment': '别担心，按计划一步步来就好。先完成最重要的事情，你比想象中更强大 🌟',
    },
    {
      'mood': '😢',
      'moodLabel': '难过',
      'content': '想家了...好想吃妈妈做的饭',
      'time': '前天 10:15',
      'aiComment': '抱抱你 🫂 想家的时候可以给家人打个视频电话，他们一定也很想你',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded,
                size: 64, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('还没有动态',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('点击右下角按钮记录你的生活',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(post['mood'] as String,
                        style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCCEB4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        post['moodLabel'] as String,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333)),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      post['time'] as String,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: const Color(0xFF999999)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(post['content'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFABD7FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🤖', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          post['aiComment'] as String,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AIChatTab extends StatefulWidget {
  const _AIChatTab();

  @override
  State<_AIChatTab> createState() => _AIChatTabState();
}

class _AIChatTabState extends State<_AIChatTab> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'content': '你好呀！我是你的AI陪伴助手，有什么想聊的吗？😊'},
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _messages.add({
        'role': 'ai',
        'content': '收到你的消息了！我会认真倾听的。能再多说说你的想法吗？🤗',
      });
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg['role'] == 'user';
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFABD7FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                            child: Text('🤖', style: TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFFF98C53)
                              : theme.colorScheme.surface,
                          borderRadius: isUser
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          msg['content']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: isUser
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCCEB4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                            child: Icon(Icons.person_rounded,
                                size: 20, color: Color(0xFFF98C53))),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '说点什么...',
                      hintStyle:
                          TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF98C53),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(14),
                  elevation: 2,
                ),
                child: const Icon(Icons.send_rounded, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
