import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_updates.dart';
import 'task_notifier.dart';

// Main HomeScreen widget which is stateful
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TaskNotifier {
  final TaskUpdates taskUpdate = TaskUpdates();

  // void logCompletion(BuildContext context, Task task) {
  //   final snackBar = SnackBar(
  //     content: Text('Task "${task.title}" has been deleted.'),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
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

  // void handleAddTask() {
  //   setState(() {
  //     taskUpdate.addTask(context, setState);
  //   });
  // }
  // Main UI of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskUpdate.titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: taskUpdate.descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: Text(
                    taskUpdate.selectedDate == null
                        ? "No date chosen!"
                        : "Due Date: ${DateFormat("yyyy-MM-dd").format(taskUpdate.selectedDate!)}",
                  ),
                ),
                TextButton(
                  onPressed: () => taskUpdate.selectDate(context, setState),
                  child: Text("Select date"),
                ),
              ],
            ),
            SizedBox(height: 20,),
            DropdownButton(
              value: taskUpdate.selectedPriority,
              items: Priority.values.map((Priority priority) {
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
              onChanged: (Priority? newValue) {
                setState(() {
                  taskUpdate.selectedPriority = newValue!;
                });
              },
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => taskUpdate.handleAddTask(setState,  taskUpdate, context),
              // onPressed: () => setState(() {
              //   taskUpdate.addTask(context, setState);
              // });

              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text("Add Task"),
            ),
            if (taskUpdate.errorMessage.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    taskUpdate.errorMessage,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: taskUpdate.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskUpdate.tasks[index];
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
                      "${task.description}\nDue Date: ${DateFormat("yyyy-MM-dd").format(task.dueDate)}\nPriority: ${taskUpdate.formatPriority(task.priority)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => taskUpdate.editTask(task, index, setState, context),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => taskUpdate.confirmDelete(context, task, index, logCompletion, setState),
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
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// // Enum to differentiate each task priority
// enum Priority { High, Medium, Low }
//
// //Base task class with properties
//
// class Task {
//   String title;
//   String description;
//   DateTime dueDate;
//   Priority priority;
//   bool isEdited;
//
//   Task({
//     required this.title,
//     required this.description,
//     required this.dueDate,
//     required this.priority,
//     this.isEdited = false,     // Indicates if the task has been edited
//   });
// }
//
// // Mixin to show a Snackbar when a task is completed
// mixin TaskNotifier {
//   void logCompletion(BuildContext context, Task task) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Task "${task.title}" completed.'),
//         duration: Duration(seconds: 5),
//       ),
//     );
//   }
// }
//
// // Main HomeScreen widget which is stateful
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TaskNotifier{
//   // Controllers to manage text input fields
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   DateTime? _selectedDate;
//   Priority _selectedPriority = Priority.Low;   // Default priority is Low
//   final List<Task> _tasks = [];    // List to store tasks
//
//   // Method to add a new task
//   void _addTask(){
//     if(_titleController.text.isNotEmpty && _selectedDate != null){
//       setState(() {
//         // Insert new task at the beginning of the list
//         // _tasks.insert(
//         //     0,
//         //     Task(
//         //       title: _titleController.text,
//         //       description: _descriptionController.text,
//         //       dueDate: _selectedDate!,
//         //       priority: _selectedPriority,
//         //     )
//         // );
//         //insert  a new task into the list
//         _tasks.add(
//         Task(
//           title: _titleController.text,
//           description: _descriptionController.text,
//           dueDate: _selectedDate!,
//           priority: _selectedPriority,
//         )
//         );
//         _sortTasks();
//         _clearTasks();   // Clear input fields after adding task
//       });
//     }
//   }
//
//
//   // Method to edit an existing task
//   void _editTask(Task task, int index) {
//     _titleController.text = task.title;
//     _descriptionController.text = task.description;
//     _selectedDate = task.dueDate;
//     _selectedPriority = task.priority;
//
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Edit Task"),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _titleController,
//                     decoration: InputDecoration(labelText: "Title"),
//                   ),
//                   TextField(
//                     controller: _descriptionController,
//                     decoration: InputDecoration(labelText: "Description"),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                           child: Text(
//                             _selectedDate == null
//                                 ? "No date chosen:"
//                                 : "Due Date: ${DateFormat("yyyy-MM-dd").format(_selectedDate!)}",
//                           ),
//                       ),
//                       TextButton(
//                         onPressed: () => _selectDate(context),
//                         child: Text("Select date"),
//                       ),
//                     ],
//                   ),
//                   DropdownButton<Priority>(
//                     value: _selectedPriority,
//                       items: Priority.values.map((Priority priority){
//                         return DropdownMenuItem<Priority>(
//                           value: priority,
//                             child: Text(priority.toString().split('.').last),
//                         );
//                       }).toList(),
//                       onChanged: (Priority? newValue) {
//                       setState(() {
//                         _selectedPriority = newValue!;
//                       });
//                       },
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     setState(() {
//                       // Update task with new values and mark as edited
//                       _tasks[index] = Task(
//                         title: _titleController.text,
//                         description: _descriptionController.text,
//                         dueDate: _selectedDate!,
//                         priority: _selectedPriority,
//                         isEdited: true,
//                       );
//                       _clearTasks();
//                     });
//                     Navigator.of(context).pop();
//                   },
//                 child: Text('Save'),
//                 ),
//                 TextButton(
//                    onPressed: () {
//                      _clearTasks();
//                       Navigator.of(context).pop();
//                   },
//                  child: Text('Cancel'),
//                 ),
//             ],
//           );
//         },
//     );
//   }
//
//   // Method to confirm deletion of a task with a dialog
// void _confirmDelete(BuildContext context, Task task, int index) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Are you done with the task?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     logCompletion(context, task);
//                     _tasks.removeAt(index);
//                   });
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('Yes'),
//               ),
//             ],
//           );
//         },
//     );
// }
//
//   // Method to show date picker and select a date
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   // Method to clear input fields
//   void _clearTasks(){
//     _titleController.clear();
//     _descriptionController.clear();
//     _selectedDate = null;
//     _selectedPriority = Priority.Low;
//   }
//
//   // Method to sort tasks by priority
//   void _sortTasks(){
//     _tasks.sort((a, b) {
//       return a.priority.index.compareTo(b.priority.index);  //will return a negative number if a.priority.index is less than b.priority.index (indicating higher priority should come first),
//     });
//   }
//
//   // Helper method to format the priority enum value
//   String _formatPriority(Priority priority) {
//     return priority.toString().split('.').last;
//   }
//
//   // Main UI of the app
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Task Manager"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: "Title"),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: "Description"),
//             ),
//             SizedBox(height: 20,),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     _selectedDate == null
//                         ? "No date chosen!"
//                         : "Due Date: ${DateFormat("yyyy-MM-dd").format(_selectedDate!)}",
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () => _selectDate(context),
//                   child: Text("Select date"),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20,),
//
//             // Dropdown for selecting priority
//             DropdownButton(
//               value: _selectedPriority,
//                 items: Priority.values.map((Priority priority){
//                   return DropdownMenuItem<Priority>(
//                     value: priority,
//                       child: Text(priority.toString().split('.').last),
//                   );
//                 }).toList(),
//                 onChanged: (Priority? newValue) {
//                 setState(() {
//                   _selectedPriority = newValue!;
//                 });
//                 },
//             ),
//             SizedBox(height: 20,),
//             ElevatedButton(
//                 onPressed: _addTask,
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                 ),
//               child: Text("Add Task"),
//             ),
//             Expanded(
//                 child: ListView.builder(
//                   itemCount: _tasks.length,
//                     itemBuilder: (context, index) {
//                     final task = _tasks[index];
//                     return ListTile(
//                       title: Row(
//                         children: [
//                           Text(task.title, style: TextStyle(fontSize: 18),),
//                         if (task.isEdited)
//                           Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                             child: Text("Edited", style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                               fontStyle: FontStyle.italic,
//                             ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       subtitle: Text(
//                         "${task.description}\nDue Date: ${DateFormat("yyyy-MM-dd").format(task.dueDate)}\nPriority: ${_formatPriority(task.priority)}",
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit),
//                             onPressed: () {
//                               _editTask(task, index);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () {
//                               _confirmDelete(context, task, index);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                     },
//                 ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
