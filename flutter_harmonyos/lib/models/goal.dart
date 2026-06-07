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

  Map<String, dynamic> toJson() => {
        'id': id,
        'goalId': goalId,
        'title': title,
        'isCompleted': isCompleted,
        'deadline': deadline.toIso8601String(),
      };

  factory SubGoal.fromJson(Map<String, dynamic> json) => SubGoal(
        id: json['id'] as String,
        goalId: json['goalId'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool? ?? false,
        deadline: DateTime.parse(json['deadline'] as String),
      );
}

class Goal {
  final String id;
  String title;
  String description;
  double progress;
  DateTime deadline;
  String iconName;
  String status;
  List<SubGoal> subGoals;
  final DateTime createdAt;

  int get remainingDays {
    final days = deadline.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  Goal({
    required this.id,
    required this.title,
    this.description = '',
    this.progress = 0.0,
    DateTime? deadline,
    this.iconName = 'school',
    this.status = '进行中',
    List<SubGoal>? subGoals,
    DateTime? createdAt,
  })  : deadline = deadline ?? DateTime.now().add(const Duration(days: 30)),
        subGoals = subGoals ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'progress': progress,
        'deadline': deadline.toIso8601String(),
        'iconName': iconName,
        'status': status,
        'subGoals': subGoals.map((s) => s.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
        deadline: DateTime.parse(json['deadline'] as String),
        iconName: json['iconName'] as String? ?? 'school',
        status: json['status'] as String? ?? '进行中',
        subGoals: (json['subGoals'] as List<dynamic>?)
                ?.map((s) => SubGoal.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}
