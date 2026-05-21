import 'package:flutter/material.dart';
import 'package:flutter_harmonyos/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    _todos = [
      Todo(id: '1', title: '复习高数第三章', priority: 3, done: true, date: now),
      Todo(id: '2', title: '写英语作文', priority: 2, done: false, date: now),
      Todo(id: '3', title: '运动30分钟', priority: 1, done: false, date: now),
      Todo(id: '4', title: '背单词50个', priority: 2, done: true, date: now),
      Todo(id: '5', title: '整理笔记', priority: 1, done: false, date: now),
      Todo(
          id: '6',
          title: '提交实验报告',
          priority: 3,
          done: false,
          date: DateTime(now.year, now.month, now.day + 1)),
      Todo(
          id: '7',
          title: '背单词100个',
          priority: 2,
          done: false,
          date: DateTime(now.year, now.month, now.day + 2)),
      Todo(
          id: '8',
          title: '整理书包',
          priority: 1,
          done: true,
          date: DateTime(now.year, now.month, now.day + 2)),
    ];
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index].done = !_todos[index].done;
      notifyListeners();
    }
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  List<Todo> getTodosForDate(DateTime date) {
    return _todos.where((t) {
      return t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day;
    }).toList();
  }

  int get completedCount =>
      _todos.where((t) => t.done && _isToday(t.date)).length;

  int get todayCount => _todos.where((t) => _isToday(t.date)).length;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
