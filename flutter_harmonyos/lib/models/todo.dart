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
}
