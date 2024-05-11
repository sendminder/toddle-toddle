import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalPushService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // LocalPushService 인스턴스 생성을 위한 Singleton 패턴
  static final LocalPushService _instance = LocalPushService._internal();
  bool _notificationsEnabled = false;

  factory LocalPushService() {
    return _instance;
  }

  LocalPushService._internal();

  Future<void> init() async {
    // Android 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      _notificationsEnabled = grantedNotificationPermission ?? false;
    }
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showNotificationWithSubtitle({
    int id = 0,
    String? title,
    String? subtitle,
    String? body,
    String? payload,
  }) async {
    if (subtitle == null) {
      await _flutterLocalNotificationsPlugin.show(id, title, body, null,
          payload: payload);
    } else {
      DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        subtitle: subtitle,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        iOS: darwinNotificationDetails,
      );
      await _flutterLocalNotificationsPlugin
          .show(id, title, body, notificationDetails, payload: payload);
    }
  }

  Future<void> showNotificationCustomSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      sound: 'slow_spring_board.aiff',
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      100,
      'custom sound notification title',
      'custom sound notification body',
      notificationDetails,
    );
  }

  void scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime startDate,
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
  }) {
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      startDate.year,
      startDate.month,
      startDate.day,
      hour,
      minute,
    );

    for (final int day in daysOfWeek) {
      final tz.TZDateTime scheduledDateWithDay = scheduledDate.add(Duration(
        // 스케쥴링할 요일까지의 차이를 계산해야함..
        // 매일은 0,1,2,3,4,5,6
        // 매주 월요일은 ..
        days: day,
      ));

      final int notificationId = id + day;

      _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDateWithDay,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '$id',
      );
    }
  }

  void cancelNotification(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}
