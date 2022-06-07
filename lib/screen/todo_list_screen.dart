import 'package:flutter/material.dart';
import 'package:hive_database_demo/screen/add_todo_screen.dart';
import 'package:hive_database_demo/screen/update_todo_screen.dart';

import '../hive_database/hive_database.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List todoList = [];
  bool? check = false;
  String daytime = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getTodoList();
    });
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String refresh = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTodo()));
          if (refresh == 'refresh') {
            print('todo list $todoList');
            getTodoList();
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(

        title: Text('Notes', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),

        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return GestureDetector(


              onTap: () async {
                String refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateTodo(
                          Id: todoList[index]['id'],
                          title:
                          todoList[index]['todoTitle'].toString(),
                          body: todoList[index]['todoBody'].toString(),
                          checkbox: todoList[index]['isCompleted'],
                          time: todoList[index]['time'].toString(),
                          date: todoList[index]['date'].toString(),
                          dayTime:
                          todoList[index]['noteTime'].toString(),
                        )));
                if (refresh == 'refresh') {
                  print('todo list $todoList');
                  getTodoList();
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Dismissible(
                    key: ValueKey<int>(todoList[index]['id']),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      HiveDB.deleteDataIntodoBox(key: todoList[index]['id'])
                          .then((value) {
                        setState(() {
                          //Navigator.pop(context);
                         // todoList.removeAt(todoList[index]['id']);
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
                                Checkbox(
                                    activeColor: Colors.lightBlue,
                                    checkColor: Colors.black,
                                    value: todoList[index]['isCompleted'],
                                    onChanged: (value) {
                                      setState(() {
                                        todoList[index]['isCompleted'] = value;
                                      });
                                    }),
                                SizedBox(
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
                                    SizedBox(
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
                               style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 27),
                            ),
                            Text(
                              todoList[index]['todoBody'].toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  //fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)
                            ),



                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
