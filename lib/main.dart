import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database_demo/screen/add_todo_screen.dart';
import 'package:hive_database_demo/screen/todo_list_screen.dart';
import 'package:hive_database_demo/screen/update_todo_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/standalone.dart';

import 'hive_database/hive_database.dart';
import 'notification/notification_manager.dart';
import 'package:timezone/timezone.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  await Hive.initFlutter();
  await HiveDB().createBox();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState(){
    super.initState();
    NotificationService.init();
    listenNotifications();

  }

  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateTodo(),
      ));

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}
