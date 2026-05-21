import 'package:flutter/material.dart';
import 'package:flutter_harmonyos/models/goal.dart';

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  GoalProvider() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    _goals = [
      Goal(
        id: 'g1',
        title: '考研上岸',
        description: '目标院校：华南理工大学，计算机科学与技术专业',
        progress: 0.50,
        remainingDays: 120,
        deadline: DateTime(now.year, now.month + 4, 1),
        subGoals: [
          SubGoal(
            id: 'sg1',
            goalId: 'g1',
            title: '完成高数一轮复习',
            isCompleted: true,
            deadline: DateTime(now.year, now.month - 1, 15),
          ),
          SubGoal(
            id: 'sg2',
            goalId: 'g1',
            title: '英语单词背完一轮',
            isCompleted: true,
            deadline: DateTime(now.year, now.month, 1),
          ),
          SubGoal(
            id: 'sg3',
            goalId: 'g1',
            title: '专业课复习开始',
            isCompleted: false,
            deadline: DateTime(now.year, now.month + 1, 15),
          ),
          SubGoal(
            id: 'sg4',
            goalId: 'g1',
            title: '政治一轮复习完成',
            isCompleted: false,
            deadline: DateTime(now.year, now.month + 2, 1),
          ),
        ],
      ),
      Goal(
        id: 'g2',
        title: '四级备考',
        description: '目标分数：550+',
        progress: 0.30,
        remainingDays: 45,
        deadline: DateTime(now.year, now.month + 1, 15),
        subGoals: [
          SubGoal(
            id: 'sg5',
            goalId: 'g2',
            title: '背完四级词汇',
            isCompleted: false,
            deadline: DateTime(now.year, now.month, 20),
          ),
          SubGoal(
            id: 'sg6',
            goalId: 'g2',
            title: '完成10套真题',
            isCompleted: false,
            deadline: DateTime(now.year, now.month + 1, 10),
          ),
        ],
      ),
      Goal(
        id: 'g3',
        title: '健身计划',
        description: '每周至少运动4次，每次30分钟以上',
        progress: 0.50,
        remainingDays: 60,
        deadline: DateTime(now.year, now.month + 2, 1),
        subGoals: [
          SubGoal(
            id: 'sg7',
            goalId: 'g3',
            title: '减重5kg',
            isCompleted: false,
            deadline: DateTime(now.year, now.month + 1, 1),
          ),
          SubGoal(
            id: 'sg8',
            goalId: 'g3',
            title: '体脂率降到20%',
            isCompleted: false,
            deadline: DateTime(now.year, now.month + 2, 1),
          ),
        ],
      ),
    ];
  }

  void _recalculateProgress(String goalId) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index == -1) return;
    final goal = _goals[index];
    if (goal.subGoals.isEmpty) return;
    final completed = goal.subGoals.where((s) => s.isCompleted).length;
    goal.progress = completed / goal.subGoals.length;
    goal.remainingDays = goal.deadline.difference(DateTime.now()).inDays;
    if (goal.remainingDays < 0) goal.remainingDays = 0;
  }

  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(String id, String title, String description,
      {DateTime? deadline}) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _goals[index].title = title;
      _goals[index].description = description;
      if (deadline != null) {
        _goals[index].deadline = deadline;
        _goals[index].remainingDays =
            deadline.difference(DateTime.now()).inDays;
        if (_goals[index].remainingDays < 0) _goals[index].remainingDays = 0;
      }
      notifyListeners();
    }
  }

  void toggleGoalStatus(String id) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _goals[index].status = _goals[index].status == '进行中' ? '已完成' : '进行中';
      notifyListeners();
    }
  }

  void updateGoalProgress(String id, double progress) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _goals[index].progress = progress;
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  void addSubGoal(String goalId, SubGoal subGoal) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index].subGoals.add(subGoal);
      _recalculateProgress(goalId);
      notifyListeners();
    }
  }

  void toggleSubGoal(String goalId, String subGoalId) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final sgIndex =
          _goals[index].subGoals.indexWhere((s) => s.id == subGoalId);
      if (sgIndex != -1) {
        _goals[index].subGoals[sgIndex].isCompleted =
            !_goals[index].subGoals[sgIndex].isCompleted;
        _recalculateProgress(goalId);
        notifyListeners();
      }
    }
  }

  void updateSubGoal(
      String goalId, String subGoalId, String title, DateTime deadline) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final sgIndex =
          _goals[index].subGoals.indexWhere((s) => s.id == subGoalId);
      if (sgIndex != -1) {
        _goals[index].subGoals[sgIndex].title = title;
        _goals[index].subGoals[sgIndex].deadline = deadline;
        notifyListeners();
      }
    }
  }

  void deleteSubGoal(String goalId, String subGoalId) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index].subGoals.removeWhere((s) => s.id == subGoalId);
      _recalculateProgress(goalId);
      notifyListeners();
    }
  }

  Goal? getGoalById(String id) {
    try {
      return _goals.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
