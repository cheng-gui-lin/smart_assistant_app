import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/providers/pomodoro_provider.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';

class UsageStatsPage extends StatelessWidget {
  const UsageStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pomodoroProvider = context.watch<PomodoroProvider>();
    final todoProvider = context.watch<TodoProvider>();

    final dailyMinutes = pomodoroProvider.getMinutesPerDay(7);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('使用统计'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_rounded,
                            size: 20, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('🍅 专注统计', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          theme,
                          '${pomodoroProvider.totalRecords}',
                          '总专注次数',
                          Icons.repeat_rounded,
                          const Color(0xFFF98C53),
                        ),
                        _buildStatItem(
                          theme,
                          '${pomodoroProvider.totalMinutes}',
                          '总专注分钟',
                          Icons.timer_outlined,
                          const Color(0xFF81C784),
                        ),
                        _buildStatItem(
                          theme,
                          pomodoroProvider.totalRecords > 0
                              ? (pomodoroProvider.totalMinutes /
                                      pomodoroProvider.totalRecords)
                                  .toStringAsFixed(0)
                              : '0',
                          '平均分钟/次',
                          Icons.analytics_rounded,
                          const Color(0xFFABD7FB),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.today_rounded,
                            size: 20, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('今日数据', style: theme.textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          theme,
                          '${pomodoroProvider.todayRecords}',
                          '今日专注次数',
                          Icons.play_circle_rounded,
                          const Color(0xFFF98C53),
                        ),
                        _buildStatItem(
                          theme,
                          '${pomodoroProvider.todayMinutes}',
                          '今日专注分钟',
                          Icons.timer_rounded,
                          const Color(0xFF81C784),
                        ),
                        _buildStatItem(
                          theme,
                          '${pomodoroProvider.completedTodosCount}',
                          '完成任务数',
                          Icons.task_alt_rounded,
                          const Color(0xFFABD7FB),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bar_chart_rounded,
                            size: 20, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('近7天专注趋势', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: dailyMinutes.entries.map((entry) {
                          final maxMinutes = dailyMinutes.values
                              .reduce((a, b) => a > b ? a : b);
                          final heightRatio =
                              maxMinutes > 0 ? entry.value / maxMinutes : 0.0;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${entry.value}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 10,
                                        color: const Color(0xFFF98C53)),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 100 * heightRatio,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF98C53).withValues(
                                          alpha: 0.6 + 0.4 * heightRatio),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.key,
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.task_alt_rounded,
                            size: 20, color: Color(0xFF81C784)),
                        const SizedBox(width: 8),
                        Text('📋 待办统计', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          theme,
                          '${todoProvider.completedCount}',
                          '今日已完成',
                          Icons.check_circle_rounded,
                          const Color(0xFF81C784),
                        ),
                        _buildStatItem(
                          theme,
                          '${todoProvider.todayCount}',
                          '今日总待办',
                          Icons.pending_rounded,
                          const Color(0xFFFFD54F),
                        ),
                        _buildStatItem(
                          theme,
                          todoProvider.todayCount > 0
                              ? '${(todoProvider.completedCount / todoProvider.todayCount * 100).toInt()}%'
                              : '0%',
                          '完成率',
                          Icons.pie_chart_rounded,
                          const Color(0xFFF98C53),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      ThemeData theme, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
