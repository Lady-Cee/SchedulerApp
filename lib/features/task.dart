import 'dart:convert';

enum Priority { High, Medium, Low }

class Task {
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  bool isEdited;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isEdited = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority.index,
    'isEdited': isEdited,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    dueDate: DateTime.parse(json['dueDate']),
    priority: Priority.values[json['priority']],
    isEdited: json['isEdited'] ?? false,
  );
}





// // Enum to differentiate each task priority
// enum Priority { High, Medium, Low }
//
//
// // Base task class with properties
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
//     this.isEdited = false, // Indicates if the task has been edited
//   });
// }
//
// // Subclass TimedTask that extends Task
// class TimedTask extends Task {
//   // Additional time-related properties can be added here in the future
//
//   TimedTask({
//     required String title,
//     required String description,
//     required DateTime dueDate,
//     required Priority priority,
//     bool isEdited = false,
//   }) : super(
//     title: title,
//     description: description,
//     dueDate: dueDate,
//     priority: priority,
//     isEdited: isEdited,
//   );
//
// // Additional time-related methods can be added here in the future
// }
