import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_harmonyos/providers/theme_provider.dart';
import 'package:flutter_harmonyos/providers/user_provider.dart';
import 'package:flutter_harmonyos/providers/pomodoro_provider.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';
import 'package:flutter_harmonyos/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProvider>();
    final pomodoroProvider = context.watch<PomodoroProvider>();
    final todoProvider = context.watch<TodoProvider>();
    final profile = userProvider.profile;
    final todayCompleted = todoProvider.completedCount;
    final todayTotal = todoProvider.todayCount;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('👤 我的'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCCEB4),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x20F98C53),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: profile.avatarBase64 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                base64Decode(profile.avatarBase64!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.person_rounded,
                              size: 48, color: Color(0xFFF98C53)),
                    ),
                    const SizedBox(height: 16),
                    Text(profile.nickname,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(profile.bio,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: const Color(0xFF999999))),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('${pomodoroProvider.totalRecords}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF98C53))),
                            const SizedBox(height: 4),
                            Text('专注次数',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: const Color(0xFF999999))),
                          ],
                        ),
                        const VerticalDivider(
                            width: 1, color: Color(0xFFE0E0E0)),
                        Column(
                          children: [
                            Text('$todayCompleted',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF98C53))),
                            const SizedBox(height: 4),
                            Text('今日完成',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: const Color(0xFF999999))),
                          ],
                        ),
                        const VerticalDivider(
                            width: 1, color: Color(0xFFE0E0E0)),
                        Column(
                          children: [
                            Text('$todayTotal',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF98C53))),
                            const SizedBox(height: 4),
                            Text('今日待办',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: const Color(0xFF999999))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCCEB4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_outline_rounded,
                          size: 20, color: Color(0xFFF98C53)),
                    ),
                    title: Text('个人信息设置',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface)),
                    subtitle: Text('编辑头像、昵称、账号',
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profileEdit);
                    },
                  ),
                  const Divider(height: 1, indent: 72, endIndent: 16),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCCEB4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        size: 20,
                        color: const Color(0xFFF98C53),
                      ),
                    ),
                    title: Text(themeProvider.isDarkMode ? '深色模式' : '浅色模式',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        themeProvider.isDarkMode ? '已切换为深色' : '已切换为浅色',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: const Color(0xFF999999))),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeColor: const Color(0xFFF98C53),
                    ),
                  ),
                  const Divider(height: 1, indent: 72, endIndent: 16),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFABD7FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.notifications_outlined,
                          size: 20, color: theme.colorScheme.onSurface),
                    ),
                    title: Text('通知设置',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface)),
                    subtitle: Text('管理推送通知',
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    onTap: () {
                      Navigator.pushNamed(
                          context, AppRoutes.notificationSettings);
                    },
                  ),
                  const Divider(height: 1, indent: 72, endIndent: 16),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2E0AA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.bar_chart_outlined,
                          size: 20, color: theme.colorScheme.onSurface),
                    ),
                    title: Text('使用统计',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface)),
                    subtitle: Text('查看学习数据统计',
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.usageStats);
                    },
                  ),
                  const Divider(height: 1, indent: 72, endIndent: 16),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCCEB4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          size: 20, color: Color(0xFFF98C53)),
                    ),
                    title: Text('关于应用',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface)),
                    subtitle: Text('版本信息与反馈',
                        style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant)),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: '随记',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '随记APP',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
