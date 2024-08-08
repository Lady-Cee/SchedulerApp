import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';
import 'task_notifier.dart';

class TaskUpdates with TaskNotifier {
  final List<Task> _tasks = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  Priority selectedPriority = Priority.Low;
  String errorMessage = " ";

  List<Task> get tasks => _tasks;

  TaskUpdates() {
    _loadTasks();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List<dynamic> tasksJson = jsonDecode(tasksString);
      _tasks.addAll(tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList());
    }
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksString = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksString);
  }

  void addTask(BuildContext context, Function setState) {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty || selectedDate == null) {
      setState(() {
        errorMessage = "Please fill in the task details!";
      });
      return;
    }
    _tasks.add(
      Task(
        title: titleController.text,
        description: descriptionController.text,
        dueDate: selectedDate!,
        priority: selectedPriority,
      ),
    );
    _sortTasks();
    clearTasks();
    setState(() {
      errorMessage = "";
    });
    _saveTasks();
  }

  void handleAddTask(Function setState, TaskUpdates taskUpdate, BuildContext context) {
    setState(() {
      taskUpdate.addTask(context, setState);
    });
  }

  void editTask(Task task, int index, Function setState, BuildContext context) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    selectedDate = task.dueDate;
    selectedPriority = task.priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "No date chosen"
                            : "Due Date: ${DateFormat("yyyy-MM-dd").format(selectedDate!)}",
                      ),
                    ),
                    TextButton(
                      onPressed: () => selectDate(context, setState),
                      child: Text("Select date"),
                    ),
                  ],
                ),
                DropdownButton<Priority>(
                  value: selectedPriority,
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (Priority? newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index] = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: selectedDate!,
                    priority: selectedPriority,
                    isEdited: true,
                  );
                  _sortTasks();
                  clearTasks();
                });
                _saveTasks();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                clearTasks();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteTask(int index, BuildContext context, Task task, Function logCompletion, Function setState) {
    if (index >= 0 && index < _tasks.length) {
      logCompletion(context, task);
      setState(() {
        _tasks.removeAt(index);
      });
      _saveTasks();
    }
  }

  void confirmDelete(BuildContext context, Task task, int index, Function logCompletion, Function setState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteTask(index, context, task, logCompletion, setState);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void clearTasks() {
    titleController.clear();
    descriptionController.clear();
    selectedDate = null;
    selectedPriority = Priority.Low;
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      return a.priority.index.compareTo(b.priority.index);
    });
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

  String formatPriority(Priority priority) {
    return priority.toString().split('.').last;
  }

  String formatDateWithSuffix(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    // Check if the date is today
    if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now)) {
      return "Today";
    }

    // Check if the date is tomorrow
    if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(tomorrow)) {
      return "Tomorrow";
    }

    // Otherwise, return the date with the correct suffix
    String day = DateFormat('d').format(date);
    String suffix;

    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)}";
  }

  // to include time
  // String formatDateWithSuffix(DateTime date) {
  //   final now = DateTime.now();
  //   final tomorrow = now.add(Duration(days: 1));
  //
  //   // Check if the date is today
  //   if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now)) {
  //     return "Today at ${DateFormat('h:mm a').format(date)}";
  //   }
  //
  //   // Check if the date is tomorrow
  //   if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(tomorrow)) {
  //     return "Tomorrow at ${DateFormat('h:mm a').format(date)}";
  //   }
  //
  //   // Otherwise, return the date with the correct suffix and time
  //   String day = DateFormat('d').format(date);
  //   String suffix;
  //
  //   if (day.endsWith('1') && !day.endsWith('11')) {
  //     suffix = 'st';
  //   } else if (day.endsWith('2') && !day.endsWith('12')) {
  //     suffix = 'nd';
  //   } else if (day.endsWith('3') && !day.endsWith('13')) {
  //     suffix = 'rd';
  //   } else {
  //     suffix = 'th';
  //   }
  //
  //   return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)} at ${DateFormat('h:mm a').format(date)}";
  // }

}




// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'task.dart';
// import 'task_notifier.dart';
//
// class TaskUpdates with TaskNotifier {
//   final List<Task> _tasks = [];
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   DateTime? selectedDate;
//   Priority selectedPriority = Priority.Low;
//   String errorMessage = " ";
//
//   List<Task> get tasks => _tasks;
//
//   void addTask(BuildContext context, Function setState) {
//     if (titleController.text.isEmpty || descriptionController.text.isEmpty || selectedDate == null) {
//       setState(() {
//         errorMessage = "Please fill in the task details!";
//       });
//       return;
//     }
//       _tasks.add(
//         Task(
//           title: titleController.text,
//           description: descriptionController.text,
//           dueDate: selectedDate!,
//           priority: selectedPriority,
//         ),
//       );
//       _sortTasks();
//       clearTasks();
//       setState((){
//         errorMessage ="";
//       });
//     }
//
//   void handleAddTask(Function setState, TaskUpdates taskUpdate, BuildContext context ) {
//     setState(() {
//       taskUpdate.addTask(context, setState);
//     });
//   }
//
//   void editTask(Task task, int index, Function setState, BuildContext context) {
//     titleController.text = task.title;
//     descriptionController.text = task.description;
//     selectedDate = task.dueDate;
//     selectedPriority = task.priority;
//
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
//                       child: Text(priority.toString().split('.').last),
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
//   void deleteTask(int index, BuildContext context, Task task, Function logCompletion, Function setState) {
//     if (index >= 0 && index < _tasks.length) {
//       logCompletion(context, task);
//       setState(() {
//         _tasks.removeAt(index);
//       });
//     }
//   }
//
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
//   void clearTasks() {
//     titleController.clear();
//     descriptionController.clear();
//     selectedDate = null;
//     selectedPriority = Priority.Low;
//   }
//
//   void _sortTasks() {
//     _tasks.sort((a, b) {
//       return a.priority.index.compareTo(b.priority.index);
//     });
//   }
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
//         selectedDate = picked;
//       });
//     }
//   }
//
//   String formatPriority(Priority priority) {
//     return priority.toString().split('.').last;
//   }
// }
//
