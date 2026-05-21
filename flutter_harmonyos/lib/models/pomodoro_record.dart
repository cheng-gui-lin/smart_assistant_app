class PomodoroRecord {
  final String id;
  final DateTime date;
  final int durationMinutes;
  String? todoId;
  String? todoTitle;
  final DateTime completedAt;

  PomodoroRecord({
    required this.id,
    required this.date,
    required this.durationMinutes,
    this.todoId,
    this.todoTitle,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();
}
