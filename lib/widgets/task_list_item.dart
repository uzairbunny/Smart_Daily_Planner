import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onCompleted;

  TaskListItem({
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final isCurrent = task.timeSlot.hour == now.hour;
    final isUpcoming = (task.timeSlot.hour > now.hour) ||
        (task.timeSlot.hour == now.hour && task.timeSlot.minute > now.minute);

    Color? tileColor;
    if (task.isCompleted) {
      tileColor = Colors.grey[300];
    } else if (isCurrent) {
      tileColor = Colors.blue[100];
    } else if (isUpcoming) {
      tileColor = Colors.green[100];
    }

    return Card(
      color: tileColor,
      child: ListTile(
        onTap: onTap,
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.description),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onCompleted(value!),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
