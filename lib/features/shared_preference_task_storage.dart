import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_mentorship_task/features/task.dart';

abstract class TaskStorage {
  Future<List<Task>> loadTasks();
  Future<void> saveTasks(List<Task> tasks);
}
class sharedPreferencesTaskStorage implements TaskStorage {
  @override
  Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List<dynamic> tasksJson = jsonDecode(tasksString);
      return tasksJson.map((tasksJson) => Task.fromJson(tasksJson)).toList();
    }
    return [];
  }
  
  @override
  Future<void> saveTasks(List<Task>tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksString);
  }
  
  
}