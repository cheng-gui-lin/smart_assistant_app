import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:flutter_harmonyos/routes/app_router.dart';
import 'package:flutter_harmonyos/pages/main_shell.dart';
import 'package:flutter_harmonyos/providers/theme_provider.dart';
import 'package:flutter_harmonyos/providers/todo_provider.dart';
import 'package:flutter_harmonyos/providers/goal_provider.dart';
import 'package:flutter_harmonyos/providers/user_provider.dart';
import 'package:flutter_harmonyos/providers/pomodoro_provider.dart';
import 'package:flutter_harmonyos/providers/life_provider.dart';
import 'package:flutter_harmonyos/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    final appDir = await pp.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);
  }

  await Hive.openBox('todos');
  await Hive.openBox('goals');
  await Hive.openBox('user_profile');
  await Hive.openBox('pomodoro_records');
  await Hive.openBox('posts');
  await Hive.openBox('chat_sessions');

  if (!kIsWeb) {
    final notificationService = NotificationService();
    await notificationService.init();
  }

  await initializeDateFormatting('zh_CN');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PomodoroProvider()),
        ChangeNotifierProvider(create: (_) => LifeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: '随记',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
      home: const MainShell(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFF98C53),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFFCCEB4),
        onPrimaryContainer: Color(0xFF7A3B12),
        secondary: Color(0xFFD2E0AA),
        onSecondary: Color(0xFF2D3D1A),
        secondaryContainer: Color(0xFFD2E0AA),
        onSecondaryContainer: Color(0xFF2D3D1A),
        tertiary: Color(0xFFABD7FB),
        onTertiary: Color(0xFF1A3D5C),
        tertiaryContainer: Color(0xFFABD7FB),
        onTertiaryContainer: Color(0xFF1A3D5C),
        error: Color(0xFFE57373),
        onError: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF333333),
        surfaceContainerHighest: Color(0xFFF9F2EF),
        onSurfaceVariant: Color(0xFF999999),
        outline: Color(0xFFE0E0E0),
        outlineVariant: Color(0xFFE0E0E0),
        shadow: Color(0x1F000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF333333),
        onInverseSurface: Color(0xFFFFFFFF),
        inversePrimary: Color(0xFFF98C53),
      ),
      scaffoldBackgroundColor: const Color(0xFFF9F2EF),
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF333333),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF98C53),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: Color(0xFF999999),
        ),
      ),
      iconTheme: const IconThemeData(
        size: 24,
        color: Color(0xFF333333),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFF98C53),
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 4,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFF98C53),
        onPrimary: Color(0xFF1A1A1A),
        primaryContainer: Color(0xFF4A2A1A),
        onPrimaryContainer: Color(0xFFFCCEB4),
        secondary: Color(0xFFD2E0AA),
        onSecondary: Color(0xFF1A1A1A),
        secondaryContainer: Color(0xFF2D3D1A),
        onSecondaryContainer: Color(0xFFD2E0AA),
        tertiary: Color(0xFFABD7FB),
        onTertiary: Color(0xFF1A1A1A),
        tertiaryContainer: Color(0xFF1A3D5C),
        onTertiaryContainer: Color(0xFFABD7FB),
        error: Color(0xFFE57373),
        onError: Color(0xFFFFFFFF),
        surface: Color(0xFF2D2D2D),
        onSurface: Color(0xFFF0F0F0),
        surfaceContainerHighest: Color(0xFF3A3A3A),
        onSurfaceVariant: Color(0xFFAAAAAA),
        outline: Color(0xFF555555),
        outlineVariant: Color(0xFF444444),
        shadow: Color(0x3F000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFF0F0F0),
        onInverseSurface: Color(0xFF1A1A1A),
        inversePrimary: Color(0xFFF98C53),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
        color: Color(0xFF2D2D2D),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF0F0F0),
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF0F0F0),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF0F0F0),
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF0F0F0),
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: Color(0xFFF0F0F0),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFFF0F0F0),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Color(0xFFAAAAAA),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF98C53),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: Color(0xFFAAAAAA),
        ),
      ),
      iconTheme: const IconThemeData(
        size: 24,
        color: Color(0xFFF0F0F0),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFF98C53),
        foregroundColor: Color(0xFF1A1A1A),
        elevation: 4,
      ),
    );
  }
}
