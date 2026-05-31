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

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'todoId': todoId,
        'todoTitle': todoTitle,
        'completedAt': completedAt.toIso8601String(),
      };

  factory PomodoroRecord.fromJson(Map<String, dynamic> json) =>
      PomodoroRecord(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        durationMinutes: json['durationMinutes'] as int,
        todoId: json['todoId'] as String?,
        todoTitle: json['todoTitle'] as String?,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}
