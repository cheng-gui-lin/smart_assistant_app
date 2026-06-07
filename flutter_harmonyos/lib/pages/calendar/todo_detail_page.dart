import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';

class TodoDetailPage extends StatelessWidget {
  final String todoId;
  const TodoDetailPage({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoProvider = context.watch<TodoProvider>();
    final todos = todoProvider.todos;
    final todo = todos.where((t) => t.id == todoId).firstOrNull;

    if (todo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('待办详情')),
        body: const Center(child: Text('待办未找到')),
      );
    }

    final priorityLabels = {3: '高优先级', 2: '中优先级', 1: '低优先级'};
    final priorityColors = {
      3: Colors.red,
      2: Colors.orange,
      1: Colors.green,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('待办详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              todoProvider.deleteTodo(todoId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('待办已删除')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: priorityColors[todo.priority]?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    priorityLabels[todo.priority] ?? '未知',
                    style: TextStyle(
                      color: priorityColors[todo.priority] ?? Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '日期: ${todo.date.year}年${todo.date.month}月${todo.date.day}日',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (todo.time != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '提醒时间: ${todo.time!.format(context)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            if (todo.description.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('描述', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(
                todo.description,
                style: theme.textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  todo.done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                  color: todo.done ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  todo.done ? '已完成' : '未完成',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
