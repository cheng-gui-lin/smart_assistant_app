import 'package:flutter/material.dart';
import 'package:flutter_harmonyos/pages/home/home_page.dart';
import 'package:flutter_harmonyos/pages/calendar/calendar_page.dart';
import 'package:flutter_harmonyos/pages/life/life_page.dart';
import 'package:flutter_harmonyos/pages/profile/profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CalendarPage(),
    LifePage(),
    ProfilePage(),
  ];

  final List<String> _titles = [
    '首页',
    '日历',
    '生活',
    '我的',
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.favorite_rounded,
    Icons.person_rounded,
  ];

  final List<IconData> _iconsOutlined = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.favorite_outlined,
    Icons.person_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          destinations: List.generate(
              4,
              (index) => NavigationDestination(
                    icon: Icon(_iconsOutlined[index], size: 24),
                    selectedIcon: Icon(_icons[index], size: 24),
                    label: _titles[index],
                  )),
          indicatorColor: const Color(0xFFFCCEB4),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
    );
  }
}
