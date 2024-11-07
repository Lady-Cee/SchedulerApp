import 'package:my_scheduler/features/combined_layout_screen/combined_home_layout.dart';
import 'package:flutter/material.dart';
import 'package:my_scheduler/features/alarm_notification.dart';

import 'features/home_screen.dart';
import 'features/web_screen/web_home-screen.dart';

void main() async {
  // Ensure that Flutter's binding is initialized before doing any asynchronous work
  WidgetsFlutterBinding.ensureInitialized();
  //
  // Initialize the alarm notification
  // final alarmNotification = AlarmNotification();
  // await alarmNotification.initNotifications();


  // Run the app
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  //const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: CombinedHomeLayout(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => HomeScreen(),
      //   '/web': (context) => WebHomeScreen(),
      // },
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:MyScheduler/features/alarm_notification.dart';
//
// import 'features/home_screen.dart';
//
// void main() async {
//   // Ensure that Flutter's binding is initialized before doing any asynchronous work
//    WidgetsFlutterBinding.ensureInitialized();
//   //
//     // Initialize the alarm notification
//   final alarmNotification = AlarmNotification();
//   await alarmNotification.initNotifications();
//
//
//   // Run the app
//   runApp(TaskManagerApp());
// }
//
// class TaskManagerApp extends StatelessWidget {
//   //const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Task Manager',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: HomeScreen(),
//         debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
//
