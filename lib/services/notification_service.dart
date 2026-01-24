import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // ---------- SINGLETON ----------
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ---------- INIT ----------
  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  // ---------- THÔNG BÁO NGAY ----------
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Instant notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  // ---------- BÁO THỨC 1 LẦN ----------
  Future<void> setAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    DateTime alarmTime = time;

    if (alarmTime.isBefore(DateTime.now())) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(alarmTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          channelDescription: 'Alarm',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // ---------- BÁO THỨC HÀNG NGÀY ----------
  Future<void> setDailyAlarm({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();

    DateTime firstTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (firstTime.isBefore(now)) {
      firstTime = firstTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(firstTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_alarm_channel',
          'Daily Alarm',
          channelDescription: 'Daily alarm',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // ---------- HUỶ ----------
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
