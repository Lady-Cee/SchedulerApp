import 'dart:convert';

// Enum to represent the priority levels of a task.
enum TaskPriority{
  Low,
  Medium,
  High,
}

// The Task class represents an individual task with various properties.
class Task {
  String title;
  String description;
  DateTime dueDate;
  TaskPriority priority;
  bool isEdited;
  bool showCheckbox;
  bool isSelected;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isEdited = false,
    this.showCheckbox = false,
    this.isSelected = false
  });

// Method to convert a Task object into a JSON-like map.

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'priority': priority.index,
    'isSelected': isSelected,
    'isEdited': isEdited,
  };

// Factory constructor to create a Task object from a JSON-like map.

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    dueDate: DateTime.parse(json['dueDate']),
    priority: TaskPriority.values[json['priority']],
    isSelected: json['isSelected'] ?? false,
    isEdited: json['isEdited'] ?? false,
  );

}


// import 'dart:convert';
//
// // Enum to represent the priority levels of a task.
// enum Priority { High, Medium, Low }
//
// // The Task class represents an individual task with various properties.
// class Task {
//   String title;
//   String description;
//   DateTime dueDate;
//   Priority priority;
//   bool isEdited;
//
//   // Constructor to initialize the Task object with required parameters.
//   Task({
//     required this.title,
//     required this.description,
//     required this.dueDate,
//     required this.priority,
//     this.isEdited = false,
//   });
//
//   // Method to convert a Task object into a JSON-like map.
//   Map<String, dynamic> toJson() => {
//     'title': title,
//     'description': description,
//     'dueDate': dueDate.toIso8601String(),
//     'priority': priority.index,
//     'isEdited': isEdited,
//   };
//
//   // Factory constructor to create a Task object from a JSON-like map.
//   factory Task.fromJson(Map<String, dynamic> json) => Task(
//     title: json['title'],
//     description: json['description'],
//     dueDate: DateTime.parse(json['dueDate']),
//     priority: Priority.values[json['priority']],
//     isEdited: json['isEdited'] ?? false,
//   );
// }


//-----------------------------------------------------------------

// toJson Method: Converts a Task object into a JSON-like map, which is useful for serializing the task to save or transmit it.
// fromJson Factory: Creates a Task object from a JSON-like map, allowing tasks to be deserialized back into objects from stored or received data. The isEdited field has a default value of false if it is not present in the JSON.
// This code structure is useful for tasks that need to be saved, loaded, or transmitted in a structured format like JSON.


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
