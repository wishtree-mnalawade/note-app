import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_database_demo/screen/todo_list_screen.dart';
import 'package:intl/intl.dart';
import '../hive_database/hive_database.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late final ValueChanged<AddTodo> onPressed;

  static int todoId = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // validated() {
  //   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
  //     print("Form Validated");
  //   } else {
  //     print("Form not validated");
  //     return;
  //   }
  // }

  late DateTime date;
  String? stime;
  String? sdate;

  final initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        title: Text('Notes', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: titleController,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 20),

                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(

                        autofocus: false,
                        controller: bodyController,
                        maxLines: 5,
                        decoration: InputDecoration(
                            labelText: 'Body',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints:
                            BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              (stime == null) ? 'Select Time' : "$stime",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          String amPm = time!.periodOffset == 0 ? 'AM' : 'PM';
                          int hour = amPm == 'PM' ? time.hour - 12 : time.hour;

                          String selectedTime = hour.toString() +
                              ' : ' +
                              time.minute.toString() +
                              ' ' +
                              amPm;
                          setState(() {
                            stime = selectedTime;
                          });
                        },

                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints:
                            BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              (sdate == null) ? "Select Date" : "$sdate",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2025),
                            initialDate: DateTime.now(),
                            //fieldHintText: "Select Date",
                          );

                          String selectedDate = date!.day.toString() +
                              '/' +
                              date.month.toString() +
                              '/' +
                              date.year.toString();
                          setState(() {
                            sdate = selectedDate;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        color: Color.fromRGBO(0, 160, 227, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                          textColor: Colors.white,
                          child: Text("Add Todo",
                              style: TextStyle(fontSize: 20)),


                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                stime != null &&
                                sdate != null) {
                              HiveDB.putDataIntodoBox(key: todoId, value: {
                                'id': todoId,
                                'todoTitle': titleController.text,
                                'todoBody': bodyController.text,
                                'isCompleted': false,
                                'time': stime,
                                'date': sdate,
                                'noteTime': '$sdate' + '$stime',
                              });
                              setState(() {
                                todoId = todoId + 1;
                              });
                              Navigator.pop(context, 'refresh');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );
                            }
                          },
                         )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
