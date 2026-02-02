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

  bool _initialized = false;

  // ---------- INIT ----------
  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    // 🔔 CHANNEL ALARM
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'alarm_channel',
        'Alarm Notifications',
        description: 'Alarm',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm471496'),
      ),
    );

    // 🔔 CHANNEL DAILY
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'daily_alarm_channel',
        'Daily Alarm',
        description: 'Daily alarm',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm471496'),
      ),
    );

    _initialized = true;
  }

  // ---------- THÔNG BÁO NGAY ----------
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'alarm_channel',
        'Alarm Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm471496'),
      ),
    );

    await _plugin.show(id, title, body, details);
  }

  // ---------- BÁO THỨC 1 LẦN ----------
  Future<void> setAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    if (time.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm471496'),
          fullScreenIntent: true,
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
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm471496'),
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // ---------- HUỶ ----------
  Future<void> cancel(int id) async => _plugin.cancel(id);

  Future<void> cancelAll() async => _plugin.cancelAll();
}
