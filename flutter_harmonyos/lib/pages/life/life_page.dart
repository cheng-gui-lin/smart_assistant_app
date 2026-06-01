import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_harmonyos/providers/life_provider.dart';
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
      ),
    );
  }
}

String _formatTime(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inDays == 0) {
    return '今天 ${DateFormat('HH:mm').format(dt)}';
  } else if (diff.inDays == 1) {
    return '昨天 ${DateFormat('HH:mm').format(dt)}';
  }
  return DateFormat('M月d日 HH:mm').format(dt);
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();

  void _confirmDelete(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除动态'),
        content: const Text('确定要删除这条动态吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<LifeProvider>().deletePost(postId);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posts = context.watch<LifeProvider>().posts;

    if (posts.isEmpty) {
      return Stack(
        children: [
          Center(
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
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.postForm),
              backgroundColor: const Color(0xFFF98C53),
              foregroundColor: Colors.white,
              elevation: 4,
              child: const Icon(Icons.edit_rounded, size: 24),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
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
                        Text(post.moodEmoji,
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
                            post.moodLabel,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333)),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(post.createdAt),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF999999)),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _confirmDelete(context, post.id),
                          child: const Icon(Icons.close,
                              size: 18, color: Color(0xFFE57373)),
                        ),
                      ],
                    ),
                    if (post.imageBase64 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      color: Colors.black,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Center(
                                    child: InteractiveViewer(
                                      minScale: 0.5,
                                      maxScale: 4,
                                      child: Image.memory(
                                        base64Decode(post.imageBase64!),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 48,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(50),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64Decode(post.imageBase64!),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (post.content.isNotEmpty)
                      Text(post.content,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontSize: 15)),
                    if (post.replies.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      ...post.replies.map((reply) => Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reply.role == 'ai' ? '🤖' : '👤',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: reply.role == 'ai'
                                          ? const Color(0xFFE8F4FD)
                                          : theme.colorScheme
                                              .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      reply.content,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                    const SizedBox(height: 8),
                    _PostReplyInput(postId: post.id),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.postForm),
            backgroundColor: const Color(0xFFF98C53),
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.edit_rounded, size: 24),
          ),
        ),
      ],
    );
  }
}

class _PostReplyInput extends StatefulWidget {
  final String postId;

  const _PostReplyInput({required this.postId});

  @override
  State<_PostReplyInput> createState() => _PostReplyInputState();
}

class _PostReplyInputState extends State<_PostReplyInput> {
  final _controller = TextEditingController();

  void _sendReply() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<LifeProvider>().replyToPost(widget.postId, text);
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
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '和AI聊聊这条动态...',
                hintStyle: TextStyle(fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              onSubmitted: (_) => _sendReply(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _sendReply,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFABD7FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded,
                size: 16, color: Color(0xFF333333)),
          ),
        ),
      ],
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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<LifeProvider>().sendToAI(text);
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
    final messages = context.watch<LifeProvider>().chatSession.messages;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isUser = msg.role == 'user';
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
                          msg.content,
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '说点什么...',
                      hintStyle:
                          TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _sendMessage,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFF98C53),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                child: const Text('发送', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
