class SubGoal {
  final String id;
  final String goalId;
  String title;
  bool isCompleted;
  DateTime deadline;

  SubGoal({
    required this.id,
    required this.goalId,
    required this.title,
    this.isCompleted = false,
    DateTime? deadline,
  }) : deadline = deadline ?? DateTime.now().add(const Duration(days: 7));
}

class Goal {
  final String id;
  String title;
  String description;
  double progress;
  int remainingDays;
  DateTime deadline;
  String iconName;
  String status;
  List<SubGoal> subGoals;

  Goal({
    required this.id,
    required this.title,
    this.description = '',
    this.progress = 0.0,
    this.remainingDays = 30,
    DateTime? deadline,
    this.iconName = 'school',
    this.status = '进行中',
    List<SubGoal>? subGoals,
  })  : deadline = deadline ?? DateTime.now().add(const Duration(days: 30)),
        subGoals = subGoals ?? [];
}
