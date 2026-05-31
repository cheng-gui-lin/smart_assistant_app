import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/routes/app_routes.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';
import 'package:flutter_harmonyos/providers/pomodoro_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  final List<String> _weekDays = ['日', '一', '二', '三', '四', '五', '六'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _selectedDate = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoProvider = context.watch<TodoProvider>();
    final pomodoroProvider = context.watch<PomodoroProvider>();
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
    final monthStr = DateFormat('yyyy年M月', 'zh_CN').format(_currentMonth);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('📅 日历'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left_rounded, size: 28),
                  color: theme.colorScheme.onSurface,
                ),
                Text(monthStr,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right_rounded, size: 28),
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekDays
                  .map((d) => SizedBox(
                        width: 40,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: firstWeekday + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < firstWeekday) {
                    return const SizedBox();
                  }
                  final day = index - firstWeekday + 1;
                  final date =
                      DateTime(_currentMonth.year, _currentMonth.month, day);
                  final isToday = _isSameDay(date, DateTime.now());
                  final isSelected =
                      _selectedDate != null && _isSameDay(date, _selectedDate!);
                  final hasTodos =
                      todoProvider.getTodosForDate(date).isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate =
                            _isSameDay(date, _selectedDate ?? DateTime(0))
                                ? null
                                : date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF98C53)
                            : (isToday
                                ? const Color(0xFFFCCEB4)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isToday || isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          if (hasTodos)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFD2E0AA),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_selectedDate != null) ...[
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildDayDetail(theme, todoProvider, pomodoroProvider),
              ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 48, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text('选择一个日期查看待办',
                        style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDayDetail(ThemeData theme, TodoProvider todoProvider,
      PomodoroProvider pomodoroProvider) {
    final todos = todoProvider.getTodosForDate(_selectedDate!);
    final doneCount = todos.where((t) => t.done).length;
    final completionRate = todos.isEmpty ? 0.0 : doneCount / todos.length;
    final dateStr = DateFormat('M月d日 EEEE', 'zh_CN').format(_selectedDate!);
    final focusMinutes =
        pomodoroProvider.getTotalMinutesForDate(_selectedDate!);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('📋 $dateStr', style: theme.textTheme.titleMedium),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.todoForm,
                      arguments: {'date': _selectedDate}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF98C53),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded, size: 16),
                      SizedBox(width: 4),
                      Text('新增待办', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (todos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 48, color: theme.colorScheme.secondary),
                      const SizedBox(height: 12),
                      Text('今天没有待办事项',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text('点击右上角添加新待办',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              ...todos.map((todo) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        todoProvider.toggleTodo(todo.id);
                      },
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
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            todo.done
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked,
                            size: 20,
                            color: todo.done
                                ? const Color(0xFF81C784)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  )),
            if (todos.isNotEmpty) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: completionRate,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFFCCEB4),
                  color: const Color(0xFF81C784),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('✅ 完成率: ${(completionRate * 100).toInt()}%',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: const Color(0xFF81C784))),
                  const Spacer(),
                  Text('⏱ 今日专注: $focusMinutes分钟',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: const Color(0xFF999999))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
