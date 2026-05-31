import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _todoReminder = true;
  bool _goalReminder = true;
  bool _daySummary = true;
  bool _pomodoro = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoReminder = prefs.getBool('todo_reminder') ?? true;
      _goalReminder = prefs.getBool('goal_reminder') ?? true;
      _daySummary = prefs.getBool('day_summary') ?? true;
      _pomodoro = prefs.getBool('pomodoro') ?? true;
    });
  }

  Future<void> _setSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      switch (key) {
        case 'todo_reminder':
          _todoReminder = value;
          break;
        case 'goal_reminder':
          _goalReminder = value;
          break;
        case 'day_summary':
          _daySummary = value;
          break;
        case 'pomodoro':
          _pomodoro = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('通知设置'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('系统通知'),
          const SizedBox(height: 8),
          _buildSwitchTile(
            theme: theme,
            icon: Icons.checklist_rounded,
            iconColor: const Color(0xFFF98C53),
            iconBgColor: const Color(0xFFFCCEB4),
            title: '待办提醒',
            subtitle: '每日未完成待办数量提醒',
            value: _todoReminder,
            onChanged: (v) => _setSetting('todo_reminder', v),
          ),
          const SizedBox(height: 4),
          _buildSwitchTile(
            theme: theme,
            icon: Icons.flag_rounded,
            iconColor: const Color(0xFFF98C53),
            iconBgColor: const Color(0xFFFCCEB4),
            title: '目标截止提醒',
            subtitle: '短期目标和长期目标即将到期时提醒',
            value: _goalReminder,
            onChanged: (v) => _setSetting('goal_reminder', v),
          ),
          const SizedBox(height: 4),
          _buildSwitchTile(
            theme: theme,
            icon: Icons.wb_sunny_rounded,
            iconColor: const Color(0xFF333333),
            iconBgColor: const Color(0xFFD2E0AA),
            title: '每日小结',
            subtitle: '每日学习和专注数据总结通知',
            value: _daySummary,
            onChanged: (v) => _setSetting('day_summary', v),
          ),
          const SizedBox(height: 4),
          _buildSwitchTile(
            theme: theme,
            icon: Icons.timer_rounded,
            iconColor: const Color(0xFF333333),
            iconBgColor: const Color(0xFFABD7FB),
            title: '番茄钟完成',
            subtitle: '专注计时结束后发送完成通知',
            value: _pomodoro,
            onChanged: (v) => _setSetting('pomodoro', v),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFF98C53),
        ),
      ),
    );
  }
}
