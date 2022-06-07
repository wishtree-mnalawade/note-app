import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_database_demo/screen/todo_list_screen.dart';

import '../hive_database/hive_database.dart';

class UpdateTodo extends StatefulWidget {
  UpdateTodo(
      {Key? key,
      this.Id = 0,
      this.title = '',
      this.body = '',
      this.checkbox = false,
      this.time = "",
      this.date = "",
      this.dayTime = ""})
      : super(key: key);
  String title = "";
  String body = "";
  int Id = 0;
  bool? checkbox;
  String? time;
  String? date;
  String? dayTime;

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateBodyController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      print("Form Validated");
    } else {
      print("Form not validated");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    updateTitleController.text = widget.title;
    updateBodyController.text = widget.body;
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: updateTitleController,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            )),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        maxLines: 5,
                        autofocus: false,
                        controller: updateBodyController,
                        decoration: InputDecoration(
                            labelText: 'Body',
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            )),
                        validator: (String? value) {
                          if (value == null || value.trim().length == 0) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Checkbox(
                          value: widget.checkbox,
                          onChanged: (value) {
                            setState(() {
                              widget.checkbox = value;
                            });
                          }),
                      SizedBox(
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
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "${widget.time}",
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
                            widget.time = selectedTime;
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
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "${widget.date}",
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
                            fieldHintText: "Select Date",
                          );

                          String selectedDate = date!.day.toString() +
                              '/' +
                              date.month.toString() +
                              '/' +
                              date.year.toString();
                          setState(() {
                            widget.date = selectedDate;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        color: Color.fromRGBO(0, 160, 227, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(
                                color: Color.fromRGBO(0, 160, 227, 1))),
                        textColor: Colors.white,
                        child:
                            Text("Update Todo", style: TextStyle(fontSize: 20)),
                        onPressed: () async {
                          HiveDB.updateDataIntodoBox(key: widget.Id, value: {
                            'id': widget.Id,
                            'todoTitle': updateTitleController.text,
                            'todoBody': updateBodyController.text,
                            'isCompleted': widget.checkbox,
                            'time': widget.time,
                            'date': widget.date,
                            'noteTime': widget.dayTime,
                          });
                          setState(() {});
                          print("***${HiveDB.todoBox.toMap()}");
                          validated();

                          Navigator.pop(context, 'refresh');

                          print("${HiveDB.todoBox.toMap()}");
                        },
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
