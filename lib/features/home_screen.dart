import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //_controller is a TexyEditingController that manages the text input field
  //it allows the user to retrive the current value of the textfield

  //_tasks is a list of strings that stores the tasks that the user entered

  final TextEditingController _controller = TextEditingController();
  final List<String> _tasks   = [];

// _addTask is a method that adds the text from the input field to the _tasks list if it is not empty.
// setState is called to notify the framework that the state has changed, which triggers a rebuild of the UI.
// _controller.text.isNotEmpty checks if the input field is not empty.
// _tasks.add(_controller.text) adds the text to the _tasks list.
// _controller.clear() clears the input field.

void _addTask(){
    if(_controller.text.isNotEmpty) {
      setState(() {
        _tasks.insert(0, _controller.text);
        _controller.clear();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( "Task Manager"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Add a task",
                suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.3),

            // Expanded widget expands to fill the available space in the parent Column.
            // ListView.builder creates a scrollable list of items dynamically.
            // itemCount: _tasks.length specifies the number of items in the list, which is the length of _tasks.
            // itemBuilder: (context, index) is a function that returns a widget for each item in the list.
            // ListTile is a widget that represents a single row in a list.
            // title: Text(_tasks[index]) sets the title of the ListTile to the task text at the current index.
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                  );
                }
              )
            )

          ]
        ),
      ) ,
    );
  }
}
