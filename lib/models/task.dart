
import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  TimeOfDay timeSlot;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.timeSlot,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timeSlot: TimeOfDay(
        hour: json['hour'],
        minute: json['minute'],
      ),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hour': timeSlot.hour,
      'minute': timeSlot.minute,
      'isCompleted': isCompleted,
    };
  }
}
