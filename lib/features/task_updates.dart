
import 'package:my_scheduler/features/shared_preference_task_storage.dart';
import 'package:my_scheduler/features/task.dart';

class TaskUpdates{
  final TaskStorage storage;

  TaskUpdates(this.storage);

  Future<List<Task>> loadTasks() => storage.loadTasks();

  Future<void> saveTasks(List<Task> tasks) => storage.saveTasks(tasks);

  void addTask(Task task, List<Task> tasks) {
    tasks.add(task);
    _sortTasks(tasks);
    saveTasks(tasks);
  }

  void editTask(Task updatedTask, int index, List<Task> tasks) {
      tasks[index] = updatedTask;
      _sortTasks(tasks);
      saveTasks(tasks);
  }

  void deleteTask(int index, List<Task> tasks) {
    if(index >=0 && index < tasks.length) {
      tasks.removeAt(index);
      saveTasks(tasks);
    }
  }

  // void _sortTasks(List<Task> tasks) {
  //   tasks.sort((a, b) {
  //     // Sorting based on priority index in descending order
  //     return b.priority.index.compareTo(a.priority.index);
  //   });
  // }
  void _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      // First, compare the priorities in descending order
      int priorityComparison = b.priority.index.compareTo(a.priority.index);

      // If priorities are the same, then compare the due dates in ascending order
      if (priorityComparison == 0) {
        return a.dueDate.compareTo(b.dueDate);
      }

      // Otherwise, return the priority comparison
      return priorityComparison;
    });
  }

}










// ----------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'task.dart';
// import 'task_notifier.dart';
//
// class TaskUpdates with TaskNotifier {
//   final List<Task> _tasks = [];   // List to store all tasks.
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   DateTime? selectedDate;
//   //TimeOfDay? selectedTime;
//   Priority selectedPriority = Priority.Low;
//   String errorMessage = " ";
//
//   List<Task> get tasks => _tasks;   // Getter to access the list of tasks.
//
//   // Constructor that loads tasks when the TaskUpdates object is created.
//   TaskUpdates() {
//     _loadTasks();
//   }
//
//   // Method to load tasks from SharedPreferences.
//   void _loadTasks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();  // Get the instance of SharedPreferences.
//     String? tasksString = prefs.getString('tasks');   // Retrieve the stored tasks.
//     if (tasksString != null) {
//       // If tasks are found, decode the JSON string and convert it into Task objects.
//       List<dynamic> tasksJson = jsonDecode(tasksString);
//       _tasks.addAll(tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList());
//     }
//   }
//
//   // Method to save tasks to SharedPreferences.
//   void _saveTasks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Convert the list of tasks into a JSON string and save it.
//     String tasksString = jsonEncode(_tasks.map((task) => task.toJson()).toList());
//     await prefs.setString('tasks', tasksString);
//   }
//
//   // Method to add a new task.
//   void addTask(BuildContext context, Function setState) {
//     // Check if the title, description, or due date is missing.
//     if (titleController.text.isEmpty || descriptionController.text.isEmpty || selectedDate == null) {
//       setState(() {
//         errorMessage = "Please fill in the task details!";
//       });
//       return;
//     }
//
// // Add the task to the list.
//     _tasks.add(
//       Task(
//         title: titleController.text,
//         description: descriptionController.text,
//         dueDate: selectedDate!,
//         priority: selectedPriority,
//       ),
//     );
//     _sortTasks();  // Sort tasks based on priority.
//     clearTasks();   // Clear input fields.
//     setState(() {
//       errorMessage = "";   // Clear error message.
//     });
//     _saveTasks();   // Save tasks to SharedPreferences.
//   }
//
//
//   // Method to handle adding a task,
//   void handleAddTask(Function setState, TaskUpdates taskUpdate, BuildContext context) {
//     setState(() {
//       taskUpdate.addTask(context, setState);
//     });
//   }
//
//   // Method to edit an existing task.
//   void editTask(Task task, int index, Function setState, BuildContext context) {
//     titleController.text = task.title;
//     descriptionController.text = task.description;
//     selectedDate = task.dueDate;
//     selectedPriority = task.priority;
//
//     // Show a dialog to edit the task.
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Edit Task"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(labelText: "Title"),
//                 ),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: "Description"),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         selectedDate == null
//                             ? "No date chosen"
//                             : "Due Date: ${DateFormat("yyyy-MM-dd").format(selectedDate!)}",
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () => selectDate(context, setState),
//                       child: Text("Select date"),
//                     ),
//                   ],
//                 ),
//                 DropdownButton<Priority>(
//                   value: selectedPriority,
//                   items: Priority.values.map((Priority priority) {
//                     return DropdownMenuItem<Priority>(
//                       value: priority,
//                       child: Text(priority.toString().split('.').last),   // Display priority as a string.
//                     );
//                   }).toList(),
//                   onChanged: (Priority? newValue) {
//                     setState(() {
//                       selectedPriority = newValue!;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _tasks[index] = Task(
//                     title: titleController.text,
//                     description: descriptionController.text,
//                     dueDate: selectedDate!,
//                     priority: selectedPriority,
//                     isEdited: true,
//                   );
//                   _sortTasks();
//                   clearTasks();
//                 });
//                 _saveTasks();
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//             TextButton(
//               onPressed: () {
//                 clearTasks();
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Method to delete a task.
//   void deleteTask(int index, BuildContext context, Task task, Function logCompletion, Function setState) {
//     if (index >= 0 && index < _tasks.length) {
//       logCompletion(context, task);
//       setState(() {
//         _tasks.removeAt(index);
//       });
//       _saveTasks();
//     }
//   }
//
//   // Method to confirm the deletion of a task.
//   void confirmDelete(BuildContext context, Task task, int index, Function logCompletion, Function setState) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Are you sure you want to delete this task?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 deleteTask(index, context, task, logCompletion, setState);
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Method to clear the input fields.
//   void clearTasks() {
//     titleController.clear();
//     descriptionController.clear();
//     selectedDate = null;
//     selectedPriority = Priority.Low;
//   }
//
//   // Method to sort tasks based on priority.
//   void _sortTasks() {
//     _tasks.sort((a, b) {
//       return a.priority.index.compareTo(b.priority.index);
//     });
//   }
//
//   // Method to select a date for the task.
//
//   Future<void> selectDate(BuildContext context, Function setState) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;  // Set the selected date.
//       });
//     }
//   }
//   // Method to format the priority for display.
//
//   String formatPriority(Priority priority) {
//     return priority.toString().split('.').last;
//   }
//
//   // Method to format the date with a suffix (e.g., 1st, 2nd).
//   String formatDateWithSuffix(DateTime date) {
//     final now = DateTime.now();
//     final tomorrow = now.add(Duration(days: 1));
//
//     // Check if the date is today
//     if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now)) {
//       return "Today";
//     }
//
//     // Check if the date is tomorrow
//     if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(tomorrow)) {
//       return "Tomorrow";
//     }
//
//     // Otherwise, return the date with the correct suffix
//     String day = DateFormat('d').format(date);
//     String suffix;
//
//     if (day.endsWith('1') && !day.endsWith('11')) {
//       suffix = 'st';
//     } else if (day.endsWith('2') && !day.endsWith('12')) {
//       suffix = 'nd';
//     } else if (day.endsWith('3') && !day.endsWith('13')) {
//       suffix = 'rd';
//     } else {
//       suffix = 'th';
//     }
//
//     return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)}";
//   }
//
// }
//
