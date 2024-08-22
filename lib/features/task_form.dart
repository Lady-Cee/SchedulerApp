import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:second_mentorship_task/features/task.dart';

class TaskForm {
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

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    selectedDate = null;
    selectedPriority = TaskPriority.Low;
  }

  // Method to select a date and time using a date picker and time picker
  Future<void> selectDate(BuildContext context, Function setState) async {
    // Show the date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3101),
    );

    if (pickedDate != null) {
      // Show the time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the picked date and time into a DateTime object
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          //print("Selected DateTime: $selectedDate"); // Debug output
        });
      }
    }
  }

  // Method to format the selected date and time in 12-hour format
  String formatDateTime() {
    if (selectedDate == null) return "";
    //return DateFormat('MMM dd yyyy at h:mm a').format(selectedDate!);
   return "${DateFormat('MMM d, yyyy').format(selectedDate!)} at ${DateFormat('h:mm a').format(selectedDate!)}";
  }
}



// import 'package:flutter/material.dart';
// import 'package:second_mentorship_task/features/task.dart';
//
// class TaskForm {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   DateTime? selectedDate;
//   TaskPriority selectedPriority = TaskPriority.Low;
//   String errorMessage = "";
//
//   bool validateForm() {
//     if (titleController.text.isEmpty ||
//         descriptionController.text.isEmpty ||
//         selectedDate == null) {
//       errorMessage = "Please complete the task details";
//       return false;
//     }
//     errorMessage = "";
//     return true;
//   }
//
//   void resetForm() {
//     titleController.clear();
//     descriptionController.clear();
//     selectedDate = null;
//     selectedPriority = TaskPriority.Low;
//   }
//
//   // Method to select a date and time using a date picker and time picker
//   Future<void> selectDate(BuildContext context, Function setState) async {
//     // Show the date picker
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null) {
//       // Show the time picker
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         // Combine the picked date and time into a DateTime object
//         setState(() {
//           selectedDate = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }
//
//   // Method to select a time using a time picker
//   Future<TimeOfDay?> selectTime(BuildContext context) async {
//     return await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//   }
//
// }
//
