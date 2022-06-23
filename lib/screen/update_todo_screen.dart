import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_database_demo/screen/todo_list_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../hive_database/hive_database.dart';
import '../notification/notification_manager.dart';
import 'package:path/path.dart';

class UpdateTodo extends StatefulWidget {
  UpdateTodo(
      {Key? key,
      this.Id = 0,
      this.title = '',
      this.body = '',
      this.checkbox = false,
      this.time = "",
      this.date = "",
      this.dayTime = "",
      this.imagePath=""})
      : super(key: key);
  String title = "";
  String body = "";
  int Id = 0;
  bool? checkbox;
  String time = "";
  String date = "";
  String? dayTime;
  String imagePath;

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController updateTitleController = TextEditingController();
  TextEditingController updateBodyController = TextEditingController();
  TextEditingController updateTimeController = TextEditingController();
  TextEditingController updateDateController = TextEditingController();

  /// functions for upload updated image
  bool error = false;
  File? updateImage;

  @override
  void initState() {
    super.initState();

    //updateImage= File(widget.imagePath);
    //updateImage != null ? File(widget.imagePath):Text('NO Image');
    widget.imagePath != "" ? updateImage= File(widget.imagePath):null;
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanently = await saveFilePermanently(image.path);
      setState(() {
        updateImage = File(imagePermanently.path);
        widget.imagePath = imagePermanently.path;
        updateImage= File(widget.imagePath);
      });
    } on PlatformException catch (e) {
      print('faileld to pick image');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  /// function fo add time its time picker

  void updateTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: this.context,
    );

    if (pickedTime != null) {
      print(pickedTime.format(this.context)); //output 10:51 PM
      DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(this.context).toString());
      //converting to DateTime so that we can further format on different pattern.
      print(parsedTime); //output 1970-01-01 22:53:00.000
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      print(formattedTime); //output 14:59:00
      //DateFormat() is from intl package, you can format the time on any pattern you need.

      setState(() {
        widget.time = formattedTime; //set the value of text field.
      });
    } else {
      print("Time is not selected");
    }
  }

  /// function fo adding date its date picker

  void updateDate() async {
    DateTime? date = await showDatePicker(
      context: this.context,
      firstDate: DateTime.now(),
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
      widget.date = selectedDate;
    });
  }

  /// function use for update notes

  void updateTodo() async {
    if (_formKey.currentState!.validate()) {
      var seduledDate = DateFormat("dd/MM/yyyy HH:mm:ss")
          .parse("${widget.date} ${widget.time}");

      if(widget.imagePath == ""){
        NotificationService.showScheduledNotification(
          title: updateTitleController.text,
          body: updateBodyController.text,
          id: widget.Id,
          seduledDate: seduledDate, //DateTime.parse('$date'),


        );
      }
      else{
        NotificationService.showImageScheduledNotification(
          title: updateTitleController.text,
          body: updateBodyController.text,
          id: widget.Id,
          seduledDate: seduledDate, //DateTime.parse('$date'),
          showImageNotification: widget.imagePath,

        );
      }



      HiveDB.updateDataIntodoBox(key: widget.Id, value: {
        'id': widget.Id,
        'todoTitle': updateTitleController.text,
        'todoBody': updateBodyController.text,
        'isCompleted': widget.checkbox,
        'time': widget.time,
        'date': widget.date,
        'noteTime': widget.dayTime,
        'imagePath': widget.imagePath,
      });
      setState(() {});
      print("***${HiveDB.todoBox.toMap()}");

      Navigator.pop(this.context, 'refresh');

      print("${HiveDB.todoBox.toMap()}");
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('please fill form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    updateTitleController.text = widget.title;
    updateBodyController.text = widget.body;
    updateTimeController.text = widget.time;
    updateDateController.text = widget.date;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// TextFormField used for update title
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
                      const SizedBox(
                        height: 20,
                      ),

                      /// TextFormField used for update body
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
                          if (value == null || value.trim().isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      /// show for update image

                      updateImage != null
                          ? Image.file(
                              updateImage!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            )
                          : const Text('NO Image'),

                      /// button for select update  image
                      Row(
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                constraints: const BoxConstraints(
                                    maxWidth: 250.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  "update image",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            onPressed: () => getImage(ImageSource.gallery),
                          ),

                          /// icon button for delete image
                          IconButton(iconSize: 50, icon: const Icon(Icons.delete_forever), onPressed: () {
                            setState(() {
                              updateImage= null;
                              widget.imagePath = "";
                              print(updateImage);
                            });
                          }, )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      /// TextFormed for update time
                      TextFormField(
                        controller: updateTimeController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.timer), labelText: "select time"),
                        readOnly: true,
                        onTap: updateTime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if ((value).compareTo(DateFormat('HH:mm:ss')
                                  .format(DateTime.now())) <
                              0) {
                            print('----------');

                            print((DateFormat('HH:mm:ss')
                                .format(DateTime.now())));

                            print('-----------');
                            print(value);

                            return 'Enter Valid time';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      /// TextFormed for update date

                      TextFormField(
                        controller: updateDateController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.date_range),
                            labelText: "select date"),
                        readOnly: true,
                        onTap: updateDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      /// Button for update the notes
                      RaisedButton(
                          padding: const EdgeInsets.all(10.0),
                          color: const Color.fromRGBO(0, 160, 227, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              side: const BorderSide(
                                  color: Color.fromRGBO(0, 160, 227, 1))),
                          textColor: Colors.white,
                          child: const Text("Update Todo",
                              style: TextStyle(fontSize: 20)),
                          onPressed: updateTodo)
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
