import 'package:flutter/material.dart';
import 'package:hive_database_demo/screen/add_todo_screen.dart';
import 'package:hive_database_demo/screen/update_todo_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../hive_database/hive_database.dart';
import '../notification/notification_manager.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key, this.payload}) : super(key: key);
  final String? payload;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {



  /// use for initializing notes
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getTodoList();
    });
    tz.initializeTimeZones();
  }

  ///
  List todoList = [];
  bool? check = false;
  String daytime = "";

  ///  this function is used for sorting notes with date and time
  getTodoList() async {
    todoList = await HiveDB.getDataFromtodoBox();
    print('=== ===todoList $todoList');
    todoList.sort((a, b) => a['noteTime'].compareTo(b['noteTime']));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),

      /// floating action button is used for adding new notes
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? refresh;
           refresh = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTodo()));
          if (refresh == 'refresh') {
            print('todo list $todoList');
            getTodoList();
          }

        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            /// this function is used for add notes list
            onTap: () async {
              String? refresh;
              refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateTodo(
                            Id: todoList[index]['id'],
                            title: todoList[index]['todoTitle'].toString(),
                            body: todoList[index]['todoBody'].toString(),
                            checkbox: todoList[index]['isCompleted'],
                            time: todoList[index]['time'].toString(),
                            date: todoList[index]['date'].toString(),
                            dayTime: todoList[index]['noteTime'].toString(),
                            imagePath: todoList[index]['imagePath'],
                          )));
              if (refresh == 'refresh') {
                print('todo list $todoList');
                getTodoList();
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(

                color: todoList[index]['isCompleted']==true ?Colors.green: Colors.blueGrey,
                // decoration: BoxDecoration(
                //     gradient: const LinearGradient(
                //       colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                //       begin: Alignment.centerLeft,
                //       end: Alignment.centerRight,
                //     ),
                //     borderRadius: BorderRadius.circular(10.0)),

                /// Dismissible is used for when we swipe note it will delete
                child: Dismissible(
                    key: ValueKey<int>(todoList[index]['id']),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      HiveDB.deleteDataIntodoBox(key: todoList[index]['id'])
                          .then((value) {
                        setState(() {
                          //Navigator.pop(context);
                          // todoList.removeAt(todoList[index]['id']);
                           NotificationService().deletenotification(todoList[index]['id']);
                          getTodoList();
                        });
                      });
                      // print("***${HiveDB.todoList.toMap()}");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                /// checkbox is show not is completed or not
                                Checkbox(
                                    activeColor: Colors.lightBlue,
                                    checkColor: Colors.black,
                                    value: todoList[index]['isCompleted'],
                                    onChanged: (value) {
                                      setState(() {
                                        todoList[index]['isCompleted'] = value;
                                        if(todoList[index]['isCompleted']){
                                          NotificationService().deletenotification(todoList[index]['id']);
                                        }


                                      });
                                    }),
                                const SizedBox(
                                  width: 220,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      todoList[index]['time'].toString(),
                                      style: const TextStyle(
                                          color: Colors.yellow,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      todoList[index]['date'].toString(),
                                      style: const TextStyle(
                                          color: Colors.brown,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              todoList[index]['todoTitle'].toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27),
                            ),
                            Text(todoList[index]['todoBody'].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    //fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
