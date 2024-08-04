

// Mixin to show a Snackbar when a task is completed
import 'package:flutter/material.dart';
import 'package:second_mentorship_task/features/task.dart';

mixin TaskNotifier {
  void logCompletion(BuildContext context, Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" completed.'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}