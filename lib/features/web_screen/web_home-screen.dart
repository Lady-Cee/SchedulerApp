import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_scheduler/features/alarm_notification.dart';
import 'package:my_scheduler/features/shared_preference_task_storage.dart';
import 'package:my_scheduler/features/task_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../task.dart';
import '../task_notifier.dart';
import '../task_updates.dart';
//import 'task.dart';
//import 'task_updates.dart';
//import 'task_notifier.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> with TaskNotifier {
  // TaskUpdates handles the logic for managing tasks (adding, editing, deleting).
  late TaskUpdates taskUpdates;
  //late SharedPreferences prefs;
  final TaskForm taskFormInput = TaskForm();
  List<Task> tasks = [];

  // _visible is used to control the visibility of an error message (blinking effect).
  bool _visible = true;
  //bool isSelected = false;
  final FocusNode _focusNode = FocusNode();

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
    //setState(() {});
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

  bool anyTaskSelected() {
    return tasks.any((task) => task.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (anyTaskSelected()) {
          setState(() {
            tasks.forEach((task) {
              task.isSelected = false;
              task.showCheckbox = false; // Hide the checkbox
            });
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Schedules"),
          backgroundColor: Colors.blue.shade200, // Make AppBar transparent
          elevation: 0, // Remove AppBar shadow
        ),
        body:  Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bkgrd4.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: taskFormInput.titleController,
                            decoration: InputDecoration(
                              labelText: "Title",
                              labelStyle: TextStyle(color:Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.bold),
                              hintText: "Enter task title",
                              hintStyle: TextStyle(color: Colors.blue,fontSize: 16, ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.yellow, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.green, width: 2),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black54, // Text color
                              fontSize: 16, // Text size
                            ),
                            cursorColor: Colors.blue,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                          TextField(
                            controller: taskFormInput.descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
                              labelStyle: TextStyle(color:Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.bold),
                              hintText: "Describe the task",
                              hintStyle: TextStyle(color: Colors.blue,fontSize: 16, ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.yellow, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.green, width: 2),
                              ),
                            ),

                            style: TextStyle(
                              color: Colors.black54, // Text color
                              fontSize: 16, // Text size
                            ),
                            cursorColor: Colors.blue,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                          Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      if (taskFormInput.selectedDate == null)
                                        TextSpan(
                                          text: "No date & time chosen!",
                                          style: TextStyle(
                                            color: Colors.red, // Red color for this part
                                            fontWeight: FontWeight.bold, // Make the text bold
                                          ),
                                        )
                                      else
                                        TextSpan(
                                          text: "Due Date & time: ${taskFormInput.formatDateTime()}",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold // Default color for the rest of the text
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // child: Text(
                                //   taskFormInput.selectedDate == null
                                //       ? "No date & time chosen!"
                                //       : "Due Date & time: ${taskFormInput.formatDateTime()}",
                                // ),
                              ),
                              TextButton(
                                onPressed: () => taskFormInput.selectDate(context, setState),
                                child: Text("Select date & time"),
                              ),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*0.03,),

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
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          // Text(taskFormInput.errorMessage, style: TextStyle(color: Colors.red)),
                          ElevatedButton(
                            onPressed: () async {
                              if (taskFormInput.validateForm()) {
                                Task newTask = Task(
                                  title: taskFormInput.titleController.text,
                                  description: taskFormInput.descriptionController.text,
                                  dueDate: taskFormInput.selectedDate!,
                                  priority: taskFormInput.selectedPriority,
                                );
                                taskUpdates.addTask(newTask, tasks);
                                taskFormInput.resetForm();

                                // Initialize the AlarmNotification and schedule the alarm
                                // final alarmNotification = AlarmNotification();
                                // await alarmNotification.initNotifications();  // Initialize before scheduling
                                // await alarmNotification.scheduleAlarm(
                                //   title: newTask.title,
                                //   description: newTask.description,
                                //   dueDate: newTask.dueDate,
                                // );

                                setState(() {});
                              } else {
                                _visible = true;
                                _startBlinking();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
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
                        ],
                      )
                  ),
                ),
                //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // Container with a fixed height for the list of tasks.
                Expanded(
                  //height: 500,
                  //height: MediaQuery.of(context).size.height * 0.9,
                  // ListView.builder dynamically builds the list of tasks.
                  child: ListView.builder(
                    itemCount: tasks.length,  // Number of tasks in the list
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            if (task.isSelected) {
                              task.isSelected = false;
                              task.showCheckbox =
                              false; // hide checkbox when unselected
                            } else {
                              task.isSelected = true;
                              task.showCheckbox = true;
                            }
                          });
                        },
                        child: Card(
                          color: Colors.blue.shade100,
                          //margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: ListTile(
                            leading: task.showCheckbox
                                ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  //task.showCheckbox = !(task.showCheckbox ?? false);
                                  task.isSelected = !task.isSelected; // Toggle selection
                                  if (!task.isSelected) {
                                    task.showCheckbox = false; // Hide checkbox when unselected
                                  }
                                });
                              },
                              child: Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Circular shape
                                  border: Border.all(
                                    color: task.isSelected ? Colors.blue : Colors.grey, // Border color based on state
                                    width: 2.0,
                                  ),
                                  color: task.isSelected ? Colors.blue : Colors.transparent, // Fill color based on state
                                ),
                                child: task.isSelected
                                    ? Icon(Icons.check, size: 16,color: Colors.white,)
                                    : null,
                              ),
                            )
                                : null,
                            title: Row(
                              children: [
                                Text(task.title, style: TextStyle(fontSize: 20),),
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
                            subtitle: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${task.description}\n",
                                    style: TextStyle(fontSize: 18, color: Colors.black, height: 1.5,),),

                                  TextSpan(
                                    text: "Due Date: ${_formatDateWithSuffix(task.dueDate)}\n",
                                    style: TextStyle(fontSize: 16, color: Colors.black, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, height: 1.5,),),
                                  TextSpan(
                                    text: "Priority: ${_formatPriority(task.priority)}",
                                    style: TextStyle(fontSize: 16,
                                      color: task.priority == TaskPriority.High ? Colors.red
                                          : task.priority == TaskPriority.Medium ? Colors.green : Colors.amber.shade700, fontWeight: FontWeight.w600, height: 1.8,),),
                                  //"${_formatDateWithSuffix(task.dueDate)} - ${_formatPriority(task.priority)}"
                                ],
                              ),
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (anyTaskSelected())
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            tasks.removeWhere((task) => task.isSelected);
                            taskUpdates.saveTasks(tasks);
                          });
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delete, color: Colors.red,),
                            Text("Delete", style: TextStyle(color: Colors.red),),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }


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
                    // Clear the form fields when Cancel is pressed
                    taskFormInput.resetForm();
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


//------------------------------------
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:MyScheduler/features/alarm_notification.dart';
// import 'package:MyScheduler/features/shared_preference_task_storage.dart';
// import 'package:MyScheduler/features/task_form.dart';
// import 'package:shared_preferences/shared_preferences.dart';
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
//   late TaskUpdates taskUpdates;
//   final TaskForm taskFormInput = TaskForm();
//   List<Task> tasks = [];
//
//   // _visible is used to control the visibility of an error message (blinking effect).
//   bool _visible = true;
//   //bool isSelected = false;
//
//   @override
//   void initState(){
//     super.initState();
//
//     // Initialize task updates and load tasks
//     taskUpdates = TaskUpdates(sharedPreferencesTaskStorage());
//     _loadTasks();
//
//     // Start blinking effect
//     _startBlinking();
//
//   }
//
//   void _loadTasks() async {
//     tasks = await taskUpdates.loadTasks();
//   }
//
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
//   bool anyTaskSelected() {
//     return tasks.any((task) => task.isSelected);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Schedules"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 16.0, right: 16),
//           child: Column(
//             children: [
//               TextField(
//                 controller: taskFormInput.titleController,
//                 decoration: InputDecoration(labelText: "Title"),
//               ),
//               TextField(
//                 controller: taskFormInput.descriptionController,
//                 decoration: InputDecoration(labelText: "Description"),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height*0.001,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       taskFormInput.selectedDate == null
//                           ? "No date & time chosen!"
//                           : "Due Date & time: ${taskFormInput.formatDateTime()}",
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => taskFormInput.selectDate(context, setState),
//                     child: Text("Select date & time"),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: MediaQuery.of(context).size.height*0.001,),
//
//               // Dropdown for selecting the task priority.
//               Container(
//                 height: MediaQuery.of(context).orientation ==
//                     Orientation.portrait
//                     ? MediaQuery.of(context).size.height * 0.05
//                     : MediaQuery.of(context).size.height * 0.1,
//                 width: MediaQuery.of(context).orientation ==
//                     Orientation.portrait
//                     ? MediaQuery.of(context).size.width * 0.3
//                     : MediaQuery.of(context).size.width * 0.15,
//                 decoration: BoxDecoration(
//                   color: Colors.lightGreen,
//                   borderRadius: BorderRadius.circular(30),),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 12, left: 12),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       dropdownColor: Colors.greenAccent,
//                       value: taskFormInput.selectedPriority,
//                       items: TaskPriority.values.map((TaskPriority priority) {
//                         return DropdownMenuItem<TaskPriority>(
//                           value: priority,
//                           child: Text(priority
//                               .toString()
//                               .split('.')
//                               .last),
//                         );
//                       }).toList(),
//                       onChanged: (TaskPriority? newValue) {
//                         setState(() {
//                           taskFormInput.selectedPriority = newValue!;    // Update the selected priority
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height*0.01,),
//               // Text(taskFormInput.errorMessage, style: TextStyle(color: Colors.red)),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (taskFormInput.validateForm()) {
//                     Task newTask = Task(
//                       title: taskFormInput.titleController.text,
//                       description: taskFormInput.descriptionController.text,
//                       dueDate: taskFormInput.selectedDate!,
//                       priority: taskFormInput.selectedPriority,
//                     );
//                     taskUpdates.addTask(newTask, tasks);
//                     taskFormInput.resetForm();
//
//                     // Initialize the AlarmNotification and schedule the alarm
//                     final alarmNotification = AlarmNotification();
//                     await alarmNotification.initNotifications();  // Initialize before scheduling
//                     await alarmNotification.scheduleAlarm(
//                       title: newTask.title,
//                       description: newTask.description,
//                       dueDate: newTask.dueDate,
//                     );
//
//                     setState(() {});
//                   } else {
//                     _visible = true;
//                     _startBlinking();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                 ),
//                 child: Text("Add Task"),
//               ),
//
//               // Error message that blinks if there is an error.
//               if (taskFormInput.errorMessage.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: AnimatedOpacity(
//                     opacity: _visible ? 1.0 : 0.0,
//                     duration: Duration(milliseconds: 500),
//                     child: Text(
//                       taskFormInput.errorMessage,
//                       style: TextStyle(
//                           color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//               // Container with a fixed height for the list of tasks.
//               Column(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.5,
//                     // ListView.builder dynamically builds the list of tasks.
//                     child: ListView.builder(
//                       itemCount: tasks.length,  // Number of tasks in the list
//                       itemBuilder: (context, index) {
//                         Task task = tasks[index];
//                         return GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               if (task.isSelected) {
//                                 task.isSelected = false;
//                                 task.showCheckbox =
//                                 false; // hide checkbox when unselected
//                               } else {
//                                 task.isSelected = true;
//                                 task.showCheckbox = true;
//                               }
//                             });
//                           },
//                           child: ListTile(
//                             leading: task.showCheckbox
//                                 ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   //task.showCheckbox = !(task.showCheckbox ?? false);
//                                   task.isSelected = !task.isSelected; // Toggle selection
//                                   if (!task.isSelected) {
//                                     task.showCheckbox = false; // Hide checkbox when unselected
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 width: 24.0,
//                                 height: 24.0,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle, // Circular shape
//                                   border: Border.all(
//                                     color: task.isSelected ? Colors.blue : Colors.grey, // Border color based on state
//                                     width: 2.0,
//                                   ),
//                                   color: task.isSelected ? Colors.blue : Colors.transparent, // Fill color based on state
//                                 ),
//                                 child: task.isSelected
//                                     ? Icon(Icons.check, size: 16,color: Colors.white,)
//                                     : null,
//                               ),
//                             )
//                                 : null,
//                             title: Row(
//                               children: [
//                                 Text(task.title, style: TextStyle(fontSize: 18),),
//                                 if (task.isEdited)
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8.0),
//                                     child: Text("Edited", style: TextStyle(
//                                       color: Colors.red,
//                                       fontSize: 12,
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             subtitle: Text(
//                               "${task.description}\nDue Date: ${_formatDateWithSuffix(
//                                   task.dueDate)}\nPriority: ${_formatPriority(
//                                   task.priority)}",
//                               //"${_formatDateWithSuffix(task.dueDate)} - ${_formatPriority(task.priority)}"
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.edit),
//                                   onPressed: () => _editTask(context, task, index),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.delete),
//                                   onPressed: () => _confirmDelete(context, task, index, logCompletion),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               if (anyTaskSelected())
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                         setState(() {
//                           tasks.removeWhere((task) => task.isSelected);
//                           taskUpdates.saveTasks(tasks);
//                         });
//                       },
//                       child: Column(
//                         children: [
//                           Icon(Icons.delete, color: Colors.red,),
//                           Text("Delete", style: TextStyle(color: Colors.red),),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   String _formatDateWithSuffix(DateTime date) {
//     final now = DateTime.now();
//     final tomorrow = now.add(Duration(days: 1));
//     final timeFormatted = DateFormat('h: mm a').format(date);
//
//     if (DateTime(now.year, now.month, now.day) ==
//         DateTime(date.year, date.month, date.day)) {
//       return "Today at $timeFormatted";
//     }
//
//     if (DateTime(tomorrow.year, tomorrow.month, tomorrow.day) ==
//         DateTime(date.year, date.month, date.day)) {
//       return "Tomorrow at $timeFormatted";
//     }
//
//     String day = date.day.toString();
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
//     return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)} at ${DateFormat('h:mm a').format(date)}";
//     //return "${day}${suffix} ${DateFormat('MMMM, yyyy').format(date)}";
//   }
//
//   String _formatPriority(TaskPriority priority) {
//     return priority.toString().split('.').last;
//   }
//
//   void _editTask(BuildContext context, Task task, int index) {
//     taskFormInput.titleController.text = task.title;
//     taskFormInput.descriptionController.text = task.description;
//     taskFormInput.selectedDate = task.dueDate;
//     taskFormInput.selectedPriority = task.priority;
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               title: Text('Edit Task'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: taskFormInput.titleController,
//                     decoration: InputDecoration(labelText: "Title"),
//                   ),
//                   TextField(
//                     controller: taskFormInput.descriptionController,
//                     decoration: InputDecoration(labelText: "Description"),
//                   ),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           taskFormInput.selectedDate == null
//                               ? "No date & time chosen!"
//                               : "Due Date & time: ${taskFormInput.formatDateTime()}",
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => taskFormInput.selectDate(context, setState),
//                         child: Text("Select date & time"),
//                       ),
//                     ],
//                   ),
//                   DropdownButton<TaskPriority>(
//                     value: taskFormInput.selectedPriority,
//                     items: TaskPriority.values.map((TaskPriority priority) {
//                       return DropdownMenuItem<TaskPriority>(
//                         value: priority,
//                         child: Text(priority.toString().split('.').last),
//                       );
//                     }).toList(),
//                     onChanged: (TaskPriority? newValue) {
//                       setState(() {
//                         taskFormInput.selectedPriority = newValue!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     if (taskFormInput.validateForm()) {
//                       Task updatedTask = Task(
//                         title: taskFormInput.titleController.text,
//                         description: taskFormInput.descriptionController.text,
//                         dueDate: taskFormInput.selectedDate!,
//                         priority: taskFormInput.selectedPriority,
//                         isEdited: true,
//                       );
//                       taskUpdates.editTask(updatedTask, index, tasks);
//                       // Clear the form fields after saving the task.
//                       taskFormInput.resetForm();
//                       setState(() {});
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text("Save"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Clear the form fields when Cancel is pressed
//                     taskFormInput.resetForm();
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("Cancel"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _confirmDelete(BuildContext context, Task task, int index, Function logCompletion) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context, ) {
//         return AlertDialog(
//           title: Text('Delete Task'),
//           content: Text('Are you sure you want to delete this task?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 taskUpdates.deleteTask(index, tasks);
//                 setState(() {});
//                 Navigator.of(context).pop();
//
//                 // Call logCompletion after the task is deleted to show the Snackbar
//                 logCompletion(context, task);
//               },
//               child: Text("Yes"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("No"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


