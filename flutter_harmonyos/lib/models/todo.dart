import 'package:flutter/material.dart';

class Todo {
  final String id;
  String title;
  String description;
  int priority;
  bool done;
  DateTime date;
  TimeOfDay? time;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 2,
    this.done = false,
    DateTime? date,
    this.time,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'done': done,
        'date': date.toIso8601String(),
        'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['time'] != null) {
      final parts = (json['time'] as String).split(':');
      time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      priority: json['priority'] as int? ?? 2,
      done: json['done'] as bool? ?? false,
      date: DateTime.parse(json['date'] as String),
      time: time,
    );
  }
}
