import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/models/todo.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';

class TodoFormPage extends StatefulWidget {
  final DateTime? initialDate;
  const TodoFormPage({super.key, this.initialDate});

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int _priority = 2;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入待办标题')),
      );
      return;
    }
    final date = _selectedDate ?? DateTime.now();
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: _descController.text.trim(),
      priority: _priority,
      date: date,
      time: _selectedTime,
    );
    context.read<TodoProvider>().addTodo(todo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增待办'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '待办标题',
                hintText: '输入待办事项',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '描述（可选）',
                hintText: '添加更多细节...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('优先级', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                    value: 3,
                    label: Text('高'),
                    icon: Icon(Icons.remove, size: 14, color: Colors.white)),
                ButtonSegment(
                    value: 2,
                    label: Text('中'),
                    icon: Icon(Icons.remove, size: 14, color: Colors.white)),
                ButtonSegment(
                    value: 1,
                    label: Text('低'),
                    icon: Icon(Icons.remove, size: 14, color: Colors.white)),
              ],
              selected: {_priority},
              onSelectionChanged: (v) => setState(() => _priority = v.first),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_selectedDate != null
                  ? '${_selectedDate!.month}/${_selectedDate!.day}'
                  : '选择日期'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(_selectedTime != null
                  ? _selectedTime!.format(context)
                  : '选择时间'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.dial,
                );
                if (time != null) setState(() => _selectedTime = time);
              },
            ),
          ],
        ),
      ),
    );
  }
}
