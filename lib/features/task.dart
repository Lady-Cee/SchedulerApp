// Enum to differentiate each task priority
enum Priority { High, Medium, Low }


// Base task class with properties
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
    this.isEdited = false, // Indicates if the task has been edited
  });
}

// Subclass TimedTask that extends Task
class TimedTask extends Task {
  // Additional time-related properties can be added here in the future

  TimedTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required Priority priority,
    bool isEdited = false,
  }) : super(
    title: title,
    description: description,
    dueDate: dueDate,
    priority: priority,
    isEdited: isEdited,
  );

// Additional time-related methods can be added here in the future
}
