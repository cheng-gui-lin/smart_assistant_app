import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/models/goal.dart';
import 'package:flutter_harmonyos/providers/goal_provider.dart';
import 'package:intl/intl.dart';

class GoalDetailPage extends StatefulWidget {
  final String goalId;
  const GoalDetailPage({super.key, required this.goalId});

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  final _subGoalController = TextEditingController();
  DateTime? _subGoalDeadline;
  late DateTime _createdDate;
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    _createdDate = DateTime.now();
  }

  @override
  void dispose() {
    _subGoalController.dispose();
    super.dispose();
  }

  void _addSubGoal() {
    final title = _subGoalController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入子目标标题')),
      );
      return;
    }
    final goalProvider = context.read<GoalProvider>();
    final subGoal = SubGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      goalId: widget.goalId,
      title: title,
      deadline: _subGoalDeadline ?? DateTime.now().add(const Duration(days: 7)),
    );
    goalProvider.addSubGoal(widget.goalId, subGoal);
    _subGoalController.clear();
    setState(() {
      _subGoalDeadline = null;
      _showAddForm = false;
    });
  }

  void _showEditGoalDialog(Goal goal) {
    final titleController = TextEditingController(text: goal.title);
    final descController = TextEditingController(text: goal.description);
    DateTime selectedDate = goal.deadline;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('编辑目标'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: '目标名称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: '描述',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 18, color: Color(0xFF999999)),
                        const SizedBox(width: 8),
                        Text(
                          '截止日期: ${DateFormat('yyyy/MM/dd').format(selectedDate)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  context.read<GoalProvider>().updateGoal(
                        widget.goalId,
                        titleController.text.trim(),
                        descController.text.trim(),
                        deadline: selectedDate,
                      );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSubGoalDialog(SubGoal subGoal) {
    final titleController = TextEditingController(text: subGoal.title);
    DateTime selectedDate = subGoal.deadline;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('编辑短期目标'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '子目标名称',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (date != null) {
                    setDialogState(() => selectedDate = date);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 18, color: Color(0xFF999999)),
                      const SizedBox(width: 8),
                      Text(
                        '截止日期: ${DateFormat('yyyy/MM/dd').format(selectedDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  context.read<GoalProvider>().updateSubGoal(
                        widget.goalId,
                        subGoal.id,
                        titleController.text.trim(),
                        selectedDate,
                      );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalProvider = context.watch<GoalProvider>();
    final goal = goalProvider.getGoalById(widget.goalId);

    if (goal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('目标详情')),
        body: const Center(child: Text('目标未找到')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('目标详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              goalProvider.deleteGoal(widget.goalId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.school,
                            size: 32, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _showEditGoalDialog(goal),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        goal.title,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.edit_rounded,
                                        size: 16,
                                        color:
                                            theme.colorScheme.onSurfaceVariant),
                                  ],
                                ),
                              ),
                              if (goal.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => _showEditGoalDialog(goal),
                                  child: Text(
                                    goal.description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              goalProvider.toggleGoalStatus(widget.goalId),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: goal.status == '已完成'
                                  ? const Color(0xFF81C784)
                                  : const Color(0xFFF98C53),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              goal.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('进度', style: theme.textTheme.titleSmall),
                        Text('${(goal.progress * 100).toInt()}%',
                            style: theme.textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: goal.progress,
                        minHeight: 12,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        color: const Color(0xFFF98C53),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _showEditGoalDialog(goal),
                          child: Text(
                            '截止: ${DateFormat('yyyy/MM/dd').format(goal.deadline)} · 剩余${goal.remainingDays}天',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '创建于 ${DateFormat('yyyy/MM/dd').format(_createdDate)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.flag_rounded,
                    size: 20, color: Color(0xFFF98C53)),
                const SizedBox(width: 8),
                Text('短期目标', style: theme.textTheme.titleMedium),
                const Spacer(),
                Text(
                  '${goal.subGoals.where((s) => s.isCompleted).length}/${goal.subGoals.length}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: const Color(0xFF999999)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (goal.subGoals.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.flag_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text('暂无短期目标',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text('在下方添加你的第一个短期目标',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...goal.subGoals.map((subGoal) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => goalProvider.toggleSubGoal(
                            widget.goalId, subGoal.id),
                        child: Icon(
                          subGoal.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked,
                          color: subGoal.isCompleted
                              ? const Color(0xFF81C784)
                              : theme.colorScheme.outline,
                          size: 24,
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () => _showEditSubGoalDialog(subGoal),
                        child: Text(
                          subGoal.title,
                          style: TextStyle(
                            decoration: subGoal.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: subGoal.isCompleted
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      subtitle: GestureDetector(
                        onTap: () => _showEditSubGoalDialog(subGoal),
                        child: Text(
                          '截止: ${DateFormat('yyyy/MM/dd').format(subGoal.deadline)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            color: theme.colorScheme.onSurfaceVariant,
                            onPressed: () => _showEditSubGoalDialog(subGoal),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            color: theme.colorScheme.onSurfaceVariant,
                            onPressed: () => goalProvider.deleteSubGoal(
                                widget.goalId, subGoal.id),
                          ),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 16),
            if (_showAddForm)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('添加短期目标', style: theme.textTheme.titleSmall),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => setState(() => _showAddForm = false),
                            child: const Icon(Icons.close_rounded,
                                size: 20, color: Color(0xFF999999)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _subGoalController,
                        decoration: const InputDecoration(
                          hintText: '输入子目标名称',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _subGoalDeadline ??
                                DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365 * 5)),
                          );
                          if (date != null) {
                            setState(() => _subGoalDeadline = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 18, color: Color(0xFF999999)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _subGoalDeadline != null
                                      ? '截止: ${DateFormat('yyyy/MM/dd').format(_subGoalDeadline!)}'
                                      : '选择截止日期',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _subGoalDeadline != null
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              if (_subGoalDeadline != null)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _subGoalDeadline = null),
                                  child: const Icon(Icons.close_rounded,
                                      size: 18, color: Color(0xFF999999)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addSubGoal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF98C53),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text('添加子目标',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: InkWell(
                  onTap: () => setState(() => _showAddForm = true),
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded,
                            size: 20, color: Color(0xFFF98C53)),
                        SizedBox(width: 8),
                        Text(
                          '添加短期目标',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF98C53),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
