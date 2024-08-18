import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
//import 'task.dart';
import 'package:second_mentorship_task/features/task.dart';

class TaskForm{
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TaskPriority selectedPriority = TaskPriority.Low;
  String errorMessage = "";

  bool validateForm() {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null) {
      errorMessage = "Please complete the task details";
      return false;
    }
    errorMessage = "";
    return true;
  }
  void resetForm(){
    titleController.clear();
    descriptionController.clear();
    selectedDate = null;
    selectedPriority = TaskPriority.Low;
  }

  Future<void> selectDate(BuildContext context, Function setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}