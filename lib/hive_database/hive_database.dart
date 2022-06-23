import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../hive_database/hive_database.dart';
import '../notification/notification_manager.dart';
import 'dart:io';
import 'package:path/path.dart';

class HiveDB {
  static late Box todoBox;
  static var titleID = 'titleId';
  static var bodyId = 'bodyId';
  //List<Map> pillReminder = [];


  createBox() async {
    todoBox = await Hive.openBox('todoBox');
  }

  /// post data to hive database

  static Future putDataIntodoBox({key, value}) async {
    todoBox.put(key, value).then((value) {
      getDataFromtodoBox();
    });
  }

  /// Get data from hive database

  static Future<dynamic> getDataFromtodoBox() async {
    return todoBox.values.cast().toList();
  }

  /// Update data from hive database

  static Future updateDataIntodoBox({key, value}) async {
    todoBox.put(key, value).then((value) {
      getDataFromtodoBox();
    });
  }

  /// Delete data from hive database

  static Future deleteDataIntodoBox({key}) async {
    todoBox.delete(key).then((value) {
      key - 1;
    });
  }

  /// Clear all data from database

  static deleteDataFromtodoBox() {
    todoBox.clear();
  }

  static deleteAll(String db) {
    Hive.box(db).clear();
  }
}
