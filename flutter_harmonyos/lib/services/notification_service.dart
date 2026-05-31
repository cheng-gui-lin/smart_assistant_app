import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  Future<bool> _isEnabled(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  Future<void> showTodoReminder(int count) async {
    if (!await _isEnabled('todo_reminder')) return;
    await _plugin.show(
      1001,
      '📋 今日待办提醒',
      '你还有 $count 项待办未完成，加油！',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_reminder',
          '待办提醒',
          channelDescription: '每日待办完成提醒',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showSubGoalReminder(String title) async {
    if (!await _isEnabled('goal_reminder')) return;
    await _plugin.show(
      1002,
      '⏰ 短期目标提醒',
      '短期目标「$title」还有 3 天截止',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'goal_reminder',
          '目标提醒',
          channelDescription: '目标截止提醒',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showGoalReminder(String title, int progress) async {
    if (!await _isEnabled('goal_reminder')) return;
    await _plugin.show(
      1003,
      '🎯 目标提醒',
      '目标「$title」还有 3 天截止，进度 $progress%',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'goal_reminder',
          '目标提醒',
          channelDescription: '目标截止提醒',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showDailySummary(
      int completed, int total, int minutes, String summary) async {
    if (!await _isEnabled('day_summary')) return;
    await _plugin.show(
      1004,
      '🌟 每日小结',
      '今日完成了 $completed/$total 个待办，专注了 $minutes 分钟。$summary',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'day_summary',
          '每日小结',
          channelDescription: '每日学习小结通知',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showStreakEncouragement(int days) async {
    await _plugin.show(
      1005,
      '🔥 连续专注 $days 天！',
      '你已经连续 $days 天专注！这是你坚持的证据，继续保持！',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak',
          '连续专注',
          channelDescription: '连续专注鼓励通知',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showPomodoroComplete(int minutes) async {
    if (!await _isEnabled('pomodoro')) return;
    await _plugin.show(
      1006,
      '🎉 专注完成！',
      '完成了 $minutes 分钟的专注',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pomodoro',
          '番茄钟',
          channelDescription: '番茄钟完成通知',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showAiCommentReady() async {
    await _plugin.show(
      1007,
      '🤖 AI 评论就绪',
      'AI 已为你的动态生成了评论，快来看看吧～',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ai_comment',
          'AI评论',
          channelDescription: 'AI评论生成完成通知',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
