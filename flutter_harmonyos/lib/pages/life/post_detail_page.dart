import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_harmonyos/providers/life_provider.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final post = context.watch<LifeProvider>().getPostById(postId);

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('动态详情')),
        body: const Center(child: Text('动态不存在')),
      );
    }

    final now = DateTime.now();
    final diff = now.difference(post.createdAt);
    String timeStr;
    if (diff.inDays == 0) {
      timeStr = '今天 ${DateFormat('HH:mm').format(post.createdAt)}';
    } else if (diff.inDays == 1) {
      timeStr = '昨天 ${DateFormat('HH:mm').format(post.createdAt)}';
    } else {
      timeStr = DateFormat('M月d日 HH:mm').format(post.createdAt);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('动态详情'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(post.moodEmoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Text(post.moodLabel, style: theme.textTheme.labelSmall),
                ),
                const Spacer(),
                Text(timeStr,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey)),
              ],
            ),
            if (post.imageBase64 != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(post.imageBase64!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (post.content.isNotEmpty)
              Text(post.content, style: theme.textTheme.bodyLarge),
            if (post.replies.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('🤖 AI 对话', style: theme.textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: 8),
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
                                  : theme.colorScheme.surfaceContainerHighest,
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
          ],
        ),
      ),
    );
  }
}
