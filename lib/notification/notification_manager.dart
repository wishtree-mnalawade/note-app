import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  /// schedule notification

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime seduledDate,

  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(seduledDate, tz.local),
         const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: "Todo App Reminder",
            importance: Importance.max,
          ),
          iOS: IOSNotificationDetails(),
        ),

        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );


  /// notification for image
  static Future showImageScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime seduledDate,
    String? showImageNotification,

  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(seduledDate, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: "Todo App Reminder",
            styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(showImageNotification!),
              largeIcon: FilePathAndroidBitmap(showImageNotification),
            ),

            importance: Importance.max,
          ),
          iOS: const IOSNotificationDetails(),
        ),

        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

  Future<void> deletenotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }


}
