import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_mentorship_task/features/shared_preference_task_storage.dart';
import 'package:second_mentorship_task/features/task_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';
import 'task_updates.dart';
import 'task_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TaskNotifier {
  // TaskUpdates handles the logic for managing tasks (adding, editing, deleting).
  late TaskUpdates taskUpdates;
  final TaskForm taskFormInput = TaskForm();
  List<Task> tasks = [];

  // _visible is used to control the visibility of an error message (blinking effect).
  bool _visible = true;

  @override
  void initState(){
    super.initState();

    // Initialize task updates and load tasks
    taskUpdates = TaskUpdates(sharedPreferencesTaskStorage());
    _loadTasks();

    // Start blinking effect
    _startBlinking();

  }

  void _loadTasks() async {
    tasks = await taskUpdates.loadTasks();
  }


  void _startBlinking() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _visible = !_visible;
        });
        _startBlinking();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: [
              TextField(
                controller: taskFormInput.titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: taskFormInput.descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.001,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      taskFormInput.selectedDate == null
                          ? "No date & time chosen!"
                          : "Due Date & time: ${taskFormInput.formatDateTime()}",
                    ),
                  ),
                  TextButton(
                    onPressed: () => taskFormInput.selectDate(context, setState),
                    child: Text("Select date & time"),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height*0.001,),

              // Dropdown for selecting the task priority.
              Container(
                height: MediaQuery.of(context).orientation ==
                    Orientation.portrait
                    ? MediaQuery.of(context).size.height * 0.05
                    : MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).orientation ==
                    Orientation.portrait
                    ? MediaQuery.of(context).size.width * 0.3
                    : MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(30),),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.greenAccent,
                      value: taskFormInput.selectedPriority,
                      items: TaskPriority.values.map((TaskPriority priority) {
                        return DropdownMenuItem<TaskPriority>(
                          value: priority,
                          child: Text(priority
                              .toString()
                              .split('.')
                              .last),
                        );
                      }).toList(),
                      onChanged: (TaskPriority? newValue) {
                        setState(() {
                          taskFormInput.selectedPriority = newValue!;    // Update the selected priority
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
             // Text(taskFormInput.errorMessage, style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: () {
                  if (taskFormInput.validateForm()) {
                    Task newTask = Task(
                      title: taskFormInput.titleController.text,
                      description: taskFormInput.descriptionController.text,
                      dueDate: taskFormInput.selectedDate!,
                      priority: taskFormInput.selectedPriority,
                    );
                    taskUpdates.addTask(newTask, tasks);
                    taskFormInput.resetForm();
                    setState(() {});
                  } else {
                    _visible = true;
                    _startBlinking();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,),
                child: Text("Add Task"),
              ),

              // Error message that blinks if there is an error.
              if (taskFormInput.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      taskFormInput.errorMessage,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Container with a fixed height for the list of tasks.
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                // ListView.builder dynamically builds the list of tasks.
                child: ListView.builder(
                  itemCount: tasks.length,  // Number of tasks in the list
                  itemBuilder: (context, index) {
                    Task task = tasks[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Text(task.title, style: TextStyle(fontSize: 18),),
                           if (task.isEdited)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text("Edited", style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        "${task.description}\nDue Date: ${_formatDateWithSuffix(
                            task.dueDate)}\nPriority: ${_formatPriority(
                            task.priority)}",
                        //"${_formatDateWithSuffix(task.dueDate)} - ${_formatPriority(task.priority)}"
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editTask(context, task, index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _confirmDelete(context, task, index, logCompletion),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String _formatDate(DateTime date) {
  //   return "${date.year}-${date.month}-${date.day}";
  // }

  // String _formatDate(DateTime date) {
  //   return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  // }


  String _formatDateWithSuffix(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final timeFormatted = DateFormat('h: mm a').format(date);

    if (DateTime(now.year, now.month, now.day) ==
        DateTime(date.year, date.month, date.day)) {
      return "Today at $timeFormatted";
    }

    if (DateTime(tomorrow.year, tomorrow.month, tomorrow.day) ==
        DateTime(date.year, date.month, date.day)) {
      return "Tomorrow at $timeFormatted";
    }

    String day = date.day.toString();
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
    return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)} at ${DateFormat('h:mm a').format(date)}";
    //return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)}";
  }

  String _formatPriority(TaskPriority priority) {
    return priority.toString().split('.').last;
  }
  // void _editTask(BuildContext context, Task task, int index) {
  //   taskFormInput.titleController.text = task.title;
  //   taskFormInput.descriptionController.text = task.description;
  //   taskFormInput.selectedDate = task.dueDate;
  //   taskFormInput.selectedPriority = task.priority;
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Edit Task'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: taskFormInput.titleController,
  //               decoration: InputDecoration(labelText: "Title"),
  //             ),
  //             TextField(
  //               controller: taskFormInput.descriptionController,
  //               decoration: InputDecoration(labelText: "Description"),
  //             ),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     taskFormInput.selectedDate == null
  //                         ? "No date chosen"
  //                         : "Due Date: ${_formatDate(taskFormInput.selectedDate!)}",
  //                   ),
  //                 ),
  //                 TextButton(
  //                   onPressed: () =>
  //                       taskFormInput.selectDate(context, setState),
  //                   child: Text("Select date"),
  //                 ),
  //               ],
  //             ),
  //             DropdownButton<TaskPriority>(
  //               value: taskFormInput.selectedPriority,
  //               items: TaskPriority.values.map((TaskPriority priority) {
  //                 return DropdownMenuItem<TaskPriority>(
  //                   value: priority,
  //                   child: Text(priority.toString().split('.').last),
  //                 );
  //               }).toList(),
  //               onChanged: (TaskPriority? newValue) {
  //                 setState(() {
  //                   taskFormInput.selectedPriority = newValue!;
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               if (taskFormInput.validateForm()) {
  //                 Task updatedTask = Task(
  //                   title: taskFormInput.titleController.text,
  //                   description: taskFormInput.descriptionController.text,
  //                   dueDate: taskFormInput.selectedDate!,
  //                   priority: taskFormInput.selectedPriority,
  //                   isEdited: true,
  //                 );
  //                 taskUpdates.editTask(updatedTask, index, tasks);
  //                 // Clear the form fields after saving the task.
  //                 taskFormInput.resetForm();
  //                 setState(() {});
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: Text("Save"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Cancel"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _editTask(BuildContext context, Task task, int index) {
    taskFormInput.titleController.text = task.title;
    taskFormInput.descriptionController.text = task.description;
    taskFormInput.selectedDate = task.dueDate;
    taskFormInput.selectedPriority = task.priority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskFormInput.titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: taskFormInput.descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          taskFormInput.selectedDate == null
                              ? "No date & time chosen!"
                              : "Due Date & time: ${taskFormInput.formatDateTime()}",
                        ),
                      ),
                      TextButton(
                        onPressed: () => taskFormInput.selectDate(context, setState),
                        child: Text("Select date & time"),
                      ),
                    ],
                  ),
                  DropdownButton<TaskPriority>(
                    value: taskFormInput.selectedPriority,
                    items: TaskPriority.values.map((TaskPriority priority) {
                      return DropdownMenuItem<TaskPriority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (TaskPriority? newValue) {
                      setState(() {
                        taskFormInput.selectedPriority = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (taskFormInput.validateForm()) {
                      Task updatedTask = Task(
                        title: taskFormInput.titleController.text,
                        description: taskFormInput.descriptionController.text,
                        dueDate: taskFormInput.selectedDate!,
                        priority: taskFormInput.selectedPriority,
                        isEdited: true,
                      );
                      taskUpdates.editTask(updatedTask, index, tasks);
                      // Clear the form fields after saving the task.
                      taskFormInput.resetForm();
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Save"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Task task, int index, Function logCompletion) {
    showDialog(
      context: context,
      builder: (BuildContext context, ) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                taskUpdates.deleteTask(index, tasks);
                setState(() {});
                Navigator.of(context).pop();

                // Call logCompletion after the task is deleted to show the Snackbar
                logCompletion(context, task);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}


//-----------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'task.dart';
// import 'task_updates.dart';
// import 'task_notifier.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TaskNotifier {
//   // TaskUpdates handles the logic for managing tasks (adding, editing, deleting).
//   final TaskUpdates taskUpdate = TaskUpdates();
//
//   // _visible is used to control the visibility of an error message (blinking effect).
//   bool _visible = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _startBlinking();
//   }
//
//   void _startBlinking() {
//     Future.delayed(Duration(milliseconds: 500), () {
//       if (mounted) {
//         setState(() {
//           _visible = !_visible;
//         });
//         _startBlinking();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Task Manager"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 16.0, right: 16),
//           child: Column(
//             children: [
//               TextField(
//                 controller: taskUpdate.titleController,
//                 decoration: InputDecoration(labelText: "Title"),
//               ),
//               TextField(
//                 controller: taskUpdate.descriptionController,
//                 decoration: InputDecoration(labelText: "Description"),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height*0.001,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       taskUpdate.selectedDate == null
//                           ? "No date chosen!"
//                           : "Due Date: ${DateFormat("yyyy-MM-dd").format(
//                           taskUpdate.selectedDate!)}",
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => taskUpdate.selectDate(context, setState),
//                     child: Text("Select date"),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: MediaQuery.of(context).size.height*0.001,),
//
//               // Dropdown for selecting the task priority.
//               Container(
//                   height: MediaQuery.of(context).orientation ==
//                       Orientation.portrait
//                       ? MediaQuery.of(context).size.height * 0.05
//                       : MediaQuery.of(context).size.height * 0.1,
//                   width: MediaQuery.of(context).orientation ==
//                       Orientation.portrait
//                       ? MediaQuery.of(context).size.width * 0.3
//                       : MediaQuery.of(context).size.width * 0.15,
//                   decoration: BoxDecoration(
//                     color: Colors.lightGreen,
//                     borderRadius: BorderRadius.circular(30),),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 12, left: 12),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       dropdownColor: Colors.greenAccent,
//                       value: taskUpdate.selectedPriority,
//                       items: Priority.values.map((Priority priority) {
//                         return DropdownMenuItem<Priority>(
//                           value: priority,
//                           child: Text(priority
//                               .toString()
//                               .split('.')
//                               .last),
//                         );
//                       }).toList(),
//                       onChanged: (Priority? newValue) {
//                         setState(() {
//                           taskUpdate.selectedPriority = newValue!;    // Update the selected priority
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height*0.01,),
//               ElevatedButton(
//                 onPressed: () =>
//                     taskUpdate.handleAddTask(setState, taskUpdate, context),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                 ),
//                 child: Text("Add Task"),
//               ),
//
//               // Error message that blinks if there is an error.
//               if (taskUpdate.errorMessage.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: AnimatedOpacity(
//                     opacity: _visible ? 1.0 : 0.0,
//                     duration: Duration(milliseconds: 500),
//                     child: Text(
//                       taskUpdate.errorMessage,
//                       style: TextStyle(
//                           color: Colors.red, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//               // Container with a fixed height for the list of tasks.
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 // ListView.builder dynamically builds the list of tasks.
//                 child: ListView.builder(
//                   itemCount: taskUpdate.tasks.length,  // Number of tasks in the list
//                   itemBuilder: (context, index) {
//                     final task = taskUpdate.tasks[index];
//                     return ListTile(
//                       title: Row(
//                         children: [
//                           Text(task.title, style: TextStyle(fontSize: 18),),
//                           if (task.isEdited)
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text("Edited", style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 12,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       subtitle: Text(
//                         "${task.description}\nDue Date: ${taskUpdate
//                             .formatDateWithSuffix(
//                             task.dueDate)}\nPriority: ${taskUpdate.formatPriority(
//                             task.priority)}",
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () =>
//                                 taskUpdate.editTask(
//                                     task, index, setState, context),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () =>
//                                 taskUpdate.confirmDelete(
//                                     context, task, index, logCompletion,
//                                     setState),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

