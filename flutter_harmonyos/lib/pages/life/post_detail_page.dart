import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;
  final String content;

  const PostDetailPage({
    super.key,
    required this.postId,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                Text('😊', style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('开心', style: theme.textTheme.labelSmall),
                ),
                const Spacer(),
                Text('今天 16:30', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content.isNotEmpty ? content : '今天图书馆学了6小时，感觉很充实！',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('🤖 AI 陪伴回复', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '太棒了！保持这个节奏，你一定可以达成目标的 💪\n\n'
                '看到你在持续努力真的很让人开心，'
                '记得也要适当休息，保持好状态哦！',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
