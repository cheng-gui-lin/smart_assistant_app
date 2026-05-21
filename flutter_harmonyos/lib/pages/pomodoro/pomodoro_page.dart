import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/models/pomodoro_record.dart';
import 'package:flutter_harmonyos/providers/pomodoro_provider.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';

class PomodoroPage extends StatefulWidget {
  final int? customMinutes;
  const PomodoroPage({super.key, this.customMinutes});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late int _totalSeconds;
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;
  String? _selectedTodoId;
  String? _selectedTodoTitle;

  @override
  void initState() {
    super.initState();
    _totalSeconds = (widget.customMinutes ?? 25) * 60;
    _remainingSeconds = _totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _onComplete();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    setState(() {});
  }

  void _resetTimer() {
    _stopTimer();
    setState(() => _remainingSeconds = _totalSeconds);
  }

  void _endTimer() {
    _stopTimer();
    _recordSession();
    _resetTimer();
  }

  void _onComplete() {
    _stopTimer();
    _recordSession();
    _showCompleteDialog();
    setState(() => _remainingSeconds = _totalSeconds);
  }

  void _recordSession() {
    final elapsed = _totalSeconds - _remainingSeconds;
    if (elapsed < 60) return;
    final minutes = (elapsed / 60).ceil();
    final pomodoroProvider = context.read<PomodoroProvider>();
    final record = PomodoroRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      durationMinutes: minutes,
      todoId: _selectedTodoId,
      todoTitle: _selectedTodoTitle,
    );
    pomodoroProvider.addRecord(record);
    if (_selectedTodoId != null) {
      context.read<TodoProvider>().toggleTodo(_selectedTodoId!);
    }
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 专注完成！'),
        content: Text(
          _selectedTodoTitle != null
              ? '完成了 ${widget.customMinutes ?? 25} 分钟的专注\n绑定待办: $_selectedTodoTitle'
              : '恭喜完成了 ${widget.customMinutes ?? 25} 分钟的专注！',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress =>
      _totalSeconds > 0 ? 1.0 - (_remainingSeconds / _totalSeconds) : 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoProvider = context.watch<TodoProvider>();
    final todayTodos = todoProvider.getTodosForDate(DateTime.now());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('专注模式'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.link_rounded,
                            size: 20, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('绑定待办',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface)),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedTodoId,
                          isExpanded: true,
                          hint: Text(
                            '选择待办任务（可不绑定）',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text('不绑定',
                                  style: TextStyle(
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                            ),
                            ...todayTodos.map((todo) => DropdownMenuItem(
                                  value: todo.id,
                                  child: Text(
                                    todo.title,
                                    style: TextStyle(
                                      decoration: todo.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: todo.done
                                          ? theme.colorScheme.onSurfaceVariant
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedTodoId = value;
                              _selectedTodoTitle = value != null
                                  ? todayTodos
                                      .firstWhere((t) => t.id == value)
                                      .title
                                  : null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.work_outline_rounded,
                            size: 24, color: Color(0xFFF98C53)),
                        const SizedBox(width: 8),
                        Text('保持专注',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface)),
                        const Spacer(),
                        const CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFFD2E0AA),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 12,
                            backgroundColor: const Color(0xFFFCCEB4),
                            color: const Color(0xFFF98C53),
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(_remainingSeconds),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF98C53),
                                    fontFamily: 'SF Mono',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '剩余 ${widget.customMinutes ?? 25} 分钟',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _resetTimer,
                          icon: const Icon(Icons.refresh_rounded, size: 24),
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 24),
                        ElevatedButton(
                          onPressed: _isRunning ? _stopTimer : _startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF98C53),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            elevation: 2,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                  _isRunning
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 24),
                              const SizedBox(width: 8),
                              Text(_isRunning ? '暂停' : '开始',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: _remainingSeconds < _totalSeconds
                              ? _endTimer
                              : null,
                          icon: const Icon(Icons.stop_rounded, size: 24),
                          color: const Color(0xFFE57373),
                          disabledColor: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  '专注时请保持安静环境，提高效率',
                  style: TextStyle(
                      fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
