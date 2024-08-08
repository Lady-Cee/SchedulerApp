import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task.dart';
import 'task_updates.dart';
import 'task_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TaskNotifier {
  final TaskUpdates taskUpdate = TaskUpdates();

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
                    // subtitle: Text(
                    //   "${task.description}\nDue Date: ${DateFormat("yyyy-MM-dd").format(task.dueDate)}\nPriority: ${taskUpdate.formatPriority(task.priority)}",
                    // ),
                    subtitle: Text(
                      "${task.description}\nDue Date: ${taskUpdate.formatDateWithSuffix(task.dueDate)}\nPriority: ${taskUpdate.formatPriority(task.priority)}",
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
// import 'task.dart';
// import 'task_updates.dart';
// import 'task_notifier.dart';
//
// // Main HomeScreen widget which is stateful
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TaskNotifier {
//   final TaskUpdates taskUpdate = TaskUpdates();
//
//
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
//   // void handleAddTask() {
//   //   setState(() {
//   //     taskUpdate.addTask(context, setState);
//   //   });
//   // }
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
//               controller: taskUpdate.titleController,
//               decoration: InputDecoration(labelText: "Title"),
//             ),
//             TextField(
//               controller: taskUpdate.descriptionController,
//               decoration: InputDecoration(labelText: "Description"),
//             ),
//             SizedBox(height: 20,),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     taskUpdate.selectedDate == null
//                         ? "No date chosen!"
//                         : "Due Date: ${DateFormat("yyyy-MM-dd").format(taskUpdate.selectedDate!)}",
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () => taskUpdate.selectDate(context, setState),
//                   child: Text("Select date"),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20,),
//             DropdownButton(
//               value: taskUpdate.selectedPriority,
//               items: Priority.values.map((Priority priority) {
//                 return DropdownMenuItem<Priority>(
//                   value: priority,
//                   child: Text(priority.toString().split('.').last),
//                 );
//               }).toList(),
//               onChanged: (Priority? newValue) {
//                 setState(() {
//                   taskUpdate.selectedPriority = newValue!;
//                 });
//               },
//             ),
//             SizedBox(height: 20,),
//             ElevatedButton(
//               onPressed: () => taskUpdate.handleAddTask(setState,  taskUpdate, context),
//               // onPressed: () => setState(() {
//               //   taskUpdate.addTask(context, setState);
//               // });
//
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.blue,
//               ),
//               child: Text("Add Task"),
//             ),
//             if (taskUpdate.errorMessage.isNotEmpty)
//               Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                 child: AnimatedOpacity(
//                   opacity: _visible ? 1.0 : 0.0,
//                   duration: Duration(milliseconds: 500),
//                   child: Text(
//                     taskUpdate.errorMessage,
//                     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: taskUpdate.tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = taskUpdate.tasks[index];
//                   return ListTile(
//                     title: Row(
//                       children: [
//                         Text(task.title, style: TextStyle(fontSize: 18),),
//                         if (task.isEdited)
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text("Edited", style: TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                               fontStyle: FontStyle.italic,
//                             ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     subtitle: Text(
//                       "${task.description}\nDue Date: ${DateFormat("yyyy-MM-dd").format(task.dueDate)}\nPriority: ${taskUpdate.formatPriority(task.priority)}",
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () => taskUpdate.editTask(task, index, setState, context),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => taskUpdate.confirmDelete(context, task, index, logCompletion, setState),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
