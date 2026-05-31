import 'dart:math' as math;
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
    final todayCompleted = todoProvider.completedCount;
    final todayTotal = todoProvider.todayCount;
    final pending = todayTotal - todayCompleted;
    final completionRate =
        todayTotal > 0 ? todayCompleted / todayTotal : 0.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('专注统计'),
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
                        Text('🍅 专注统计',
                            style: theme.textTheme.titleMedium),
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
                        const Icon(Icons.today_rounded,
                            size: 20, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('今日数据',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomPaint(
                            painter: _DonutChartPainter(
                              completed: todayCompleted,
                              pending: pending,
                              completionRate: completionRate,
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(completionRate * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF98C53),
                                  ),
                                ),
                                Text(
                                  '完成率',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF999999)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                            '已完成', const Color(0xFF81C784), todayCompleted),
                        const SizedBox(width: 32),
                        _buildLegendItem(
                            '未完成', const Color(0xFFFCCEB4), pending),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          theme,
                          '$todayCompleted',
                          '今日已完成',
                          Icons.check_circle_rounded,
                          const Color(0xFF81C784),
                        ),
                        _buildStatItem(
                          theme,
                          '$todayTotal',
                          '今日总待办',
                          Icons.pending_rounded,
                          const Color(0xFFFFD54F),
                        ),
                        _buildStatItem(
                          theme,
                          '${(completionRate * 100).toInt()}%',
                          '完成率',
                          Icons.pie_chart_rounded,
                          const Color(0xFFF98C53),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_rounded,
                            size: 14, color: Color(0xFF999999)),
                        const SizedBox(width: 4),
                        Text(
                          '今日专注 ${pomodoroProvider.todayMinutes} 分钟 · '
                          '${pomodoroProvider.todayRecords} 次',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF999999)),
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
                        Text('近7天专注趋势',
                            style: theme.textTheme.titleMedium),
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
                          final heightRatio = maxMinutes > 0
                              ? entry.value / maxMinutes
                              : 0.0;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${entry.value}',
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(
                                            fontSize: 10,
                                            color: const Color(0xFFF98C53)),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 100 * heightRatio,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF98C53)
                                          .withValues(alpha: 0.6 +
                                              0.4 * heightRatio),
                                      borderRadius:
                                          const BorderRadius.vertical(
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text('$label ($count)',
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
      ],
    );
  }

  Widget _buildStatItem(ThemeData theme, String value, String label,
      IconData icon, Color color) {
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

class _DonutChartPainter extends CustomPainter {
  final int completed;
  final int pending;
  final double completionRate;

  _DonutChartPainter({
    required this.completed,
    required this.pending,
    required this.completionRate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final strokeWidth = 28.0;

    final bgPaint = Paint()
      ..color = const Color(0xFFFCCEB4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final completedPaint = Paint()
      ..color = const Color(0xFF81C784)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (completionRate > 0) {
      final sweepAngle = 2 * math.pi * completionRate;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        completedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.completionRate != completionRate;
  }
}
