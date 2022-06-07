import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database_demo/screen/add_todo_screen.dart';
import 'package:hive_database_demo/screen/todo_list_screen.dart';
import 'package:hive_flutter/adapters.dart';

import 'hive_database/hive_database.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveDB().createBox();
  runApp(MaterialApp(

    initialRoute: '/todolist',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/todolist': (context) => const TodoList(),
      // When navigating to the "/second" route, build the SecondScreen widget.

    },
  )
  );
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     /// wrap MaterialApp in Provider widget
//     return ChangeNotifierProvider(
//       create: (context) => TodoProvider(), // ← create/init your state model
//       child: MaterialApp(
//           home: TodoList()
//       ),
//     );
//   }
// }


