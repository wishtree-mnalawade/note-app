import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../hive_database/hive_database.dart';
import '../notification/notification_manager.dart';
import 'dart:io';
import 'package:path/path.dart';
class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();

  late final ValueChanged<AddTodo> onPressed;

  static int todoId = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController stime = TextEditingController();
  TextEditingController sdate = TextEditingController();

  ///  For date and time

  String dateSelected = '';
  String selectedTime = '';
  final initialDate = DateTime.now();
  final initialTime = TimeOfDay.now();
  late DateTime date;

  /// functions for upload image
  File? _image;
  bool error = false;
  String imagepath="";

  Future getImage(ImageSource source)async{
    try{
      final image =await ImagePicker()
          .pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanently = await saveFilePermanently(image.path);
      setState(() {
        _image = imagePermanently;
        imagepath = (imagePermanently.path);
        print(imagepath);

      });
    } on PlatformException catch(e){
      print('faileld to pick image');
    }
  }

  Future<File> saveFilePermanently(String imagePath)async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  /// function for add time its time picker

  void addTime() async {
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
        stime.text = formattedTime; //set the value of text field.
      });
    } else {
      print("Time is not selected");
    }
  }

  /// function fo adding date its date picker

  void addDate() async {
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
      sdate.text = selectedDate;
    });
  }

  /// Function for add notes

  void addTodo() async {
    if (_formKey.currentState!.validate()) {
      var seduledDate = DateFormat("dd/MM/yyyy HH:mm:ss")
          .parse("${sdate.text} ${stime.text}");

      if(imagepath== ""){

        NotificationService.showScheduledNotification(
          title: titleController.text,
          body: bodyController.text,
          id: todoId,
          seduledDate: seduledDate , //DateTime.parse('$date'),

        );

      }else{
        NotificationService.showImageScheduledNotification(
            title: titleController.text,
            body: bodyController.text,
            id: todoId,
            seduledDate: seduledDate , //DateTime.parse('$date'),
            showImageNotification: imagepath,
        );

            }





      print('-------------------------------------------');
      print(imagepath);

      HiveDB.putDataIntodoBox(key: todoId, value: {
        'id': todoId,
        'todoTitle': titleController.text,
        'todoBody': bodyController.text,
        'isCompleted': false,
        'time': stime.text,
        'date': sdate.text,
        'noteTime': '$sdate' '$stime',
        'imagePath': imagepath,
      });
      setState(() {
        todoId = todoId + 1;
      });
      Navigator.pop(this.context, 'refresh');
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('please fill form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// TextFormField for Add title
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
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
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
                        height: 20,
                      ),

                      /// TextFormField for Add body
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
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.black),
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


                      /// show image

                      _image != null ? Image.file( _image!,width: 160,height: 160,fit: BoxFit.cover,):Text(""),


                      /// button for select image
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
                                  "select image",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            onPressed:()=> getImage(ImageSource.gallery),
                          ),
                          SizedBox(width: 5,),

                          /// icon button for delete image
                          IconButton(iconSize: 50, icon: Icon(Icons.delete_forever), onPressed: () {
                           setState(() {
                             _image=null;
                             imagepath="";

                           });
                          }, )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      /// TextFormed for add time
                      TextFormField(
                        controller: stime,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.timer), labelText: "select time"),
                        readOnly: true,
                        onTap: addTime,
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

                      /// TextFormed for add date

                      TextFormField(
                        controller: sdate,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.date_range),
                            labelText: "select date"),
                        readOnly: true,
                        onTap: addDate,
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

                      ///Button for add Notes
                      RaisedButton(
                          padding: const EdgeInsets.all(10.0),
                          color: const Color.fromRGBO(0, 160, 227, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              side: const BorderSide(
                                  color: Color.fromRGBO(0, 160, 227, 1))),
                          textColor: Colors.white,
                          child: const Text("Add Todo",
                              style: TextStyle(fontSize: 20)),
                          onPressed: addTodo)
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
