import 'package:flutter/material.dart';
import 'package:flutter_harmonyos/routes/app_routes.dart';
import 'package:flutter_harmonyos/pages/calendar/todo_form_page.dart';
import 'package:flutter_harmonyos/pages/calendar/todo_detail_page.dart';
import 'package:flutter_harmonyos/pages/calendar/goal_form_page.dart';
import 'package:flutter_harmonyos/pages/calendar/goal_detail_page.dart';
import 'package:flutter_harmonyos/pages/life/post_form_page.dart';
import 'package:flutter_harmonyos/pages/life/post_detail_page.dart';
import 'package:flutter_harmonyos/pages/pomodoro/pomodoro_page.dart';
import 'package:flutter_harmonyos/pages/profile/profile_edit_page.dart';
import 'package:flutter_harmonyos/pages/profile/usage_stats_page.dart';
import 'package:flutter_harmonyos/pages/profile/notification_settings_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.pomodoro:
        final customMinutes = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => PomodoroPage(customMinutes: customMinutes),
        );
      case AppRoutes.todoForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TodoFormPage(initialDate: args?['date'] as DateTime?),
        );
      case AppRoutes.todoDetail:
        final todoId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TodoDetailPage(todoId: todoId ?? ''),
        );
      case AppRoutes.goalForm:
        return MaterialPageRoute(
          builder: (_) => const GoalFormPage(),
        );
      case AppRoutes.goalDetail:
        final goalId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => GoalDetailPage(goalId: goalId ?? ''),
        );
      case AppRoutes.postForm:
        return MaterialPageRoute(
          builder: (_) => const PostFormPage(),
        );
      case AppRoutes.postDetail:
        final postId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => PostDetailPage(
            postId: postId ?? '',
          ),
        );
      case AppRoutes.profileEdit:
        return MaterialPageRoute(
          builder: (_) => const ProfileEditPage(),
        );
      case AppRoutes.usageStats:
        return MaterialPageRoute(
          builder: (_) => const UsageStatsPage(),
        );
      case AppRoutes.notificationSettings:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('未找到路由: ${settings.name}')),
          ),
        );
    }
  }
}
