import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/routes/app_routes.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';
import 'package:flutter_harmonyos/providers/goal_provider.dart';
import 'package:flutter_harmonyos/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showCustomTimerDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('自定义番茄钟'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '时长',
                  hintText: '25',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('分钟', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final minutes = int.tryParse(controller.text);
              if (minutes != null && minutes > 0) {
                Navigator.pushNamed(context, AppRoutes.pomodoro,
                    arguments: minutes);
              }
            },
            child: const Text('开始'),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 3:
        return const Color(0xFFE57373);
      case 2:
        return const Color(0xFFFFD54F);
      case 1:
        return const Color(0xFF81C784);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoProvider = context.watch<TodoProvider>();
    final goalProvider = context.watch<GoalProvider>();
    final userProvider = context.watch<UserProvider>();
    final now = DateTime.now();
    final greeting =
        now.hour < 12 ? '☀️ 早上好' : (now.hour < 18 ? '🌤️ 下午好' : '🌙 晚上好');
    final dateStr = DateFormat('M月d日 EEEE', 'zh_CN').format(now);

    final todayTodos = todoProvider.getTodosForDate(now);
    final completedTodos = todayTodos.where((t) => t.done).length;
    final totalTodos = todayTodos.length;
    final progress = totalTodos > 0 ? completedTodos / totalTodos : 0.0;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              '$greeting，${userProvider.profile.nickname}',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(dateStr,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xFF999999))),
            const SizedBox(height: 24),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('📋 今日待办', style: theme.textTheme.titleMedium),
                        Text('已完成 $completedTodos/$totalTodos',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF999999))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: const Color(0xFFFCCEB4),
                        color: const Color(0xFFF98C53),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFFF98C53)),
                        ),
                        const Spacer(),
                        Text('继续加油！',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF999999))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: todayTodos
                          .take(5)
                          .map((todo) => GestureDetector(
                                onTap: () {
                                  todoProvider.toggleTodo(todo.id);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: _priorityColor(todo.priority),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _priorityColor(todo.priority)
                                                .withAlpha(180),
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          todo.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            decoration: todo.done
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: todo.done
                                                ? theme.colorScheme
                                                    .onSurfaceVariant
                                                : theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        todo.done
                                            ? Icons.check_circle_rounded
                                            : Icons.radio_button_unchecked,
                                        color: todo.done
                                            ? const Color(0xFF81C784)
                                            : theme.colorScheme.outline,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_rounded,
                            size: 24, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('🍅 番茄钟', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF98C53),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        '25:00',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF98C53),
                          fontFamily: 'SF Mono',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.pomodoro,
                                arguments: 25);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF98C53),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            elevation: 0,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.play_arrow_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('快速开始',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: _showCustomTimerDialog,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFF98C53)),
                            foregroundColor: const Color(0xFFF98C53),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.tune_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('自定义', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, size: 20, color: Color(0xFFF98C53)),
                const SizedBox(width: 8),
                Text('🎯 目标进度', style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.goalForm);
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('新增'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFF98C53),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int crossAxisCount;
                if (width <= 400) {
                  crossAxisCount = 2;
                } else if (width <= 700) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 4;
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: goalProvider.goals.length,
                  itemBuilder: (context, index) {
                    final goal = goalProvider.goals[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.goalDetail,
                            arguments: goal.id);
                      },
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school,
                                      size: 20, color: const Color(0xFFF98C53)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      goal.title,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: goal.progress,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFFFCCEB4),
                                  color: const Color(0xFFF98C53),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(goal.progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF98C53),
                                    ),
                                  ),
                                  Text(
                                    '剩余${goal.remainingDays}天',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF999999)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
