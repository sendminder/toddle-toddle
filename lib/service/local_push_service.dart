import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:toddle_toddle/const/cheer_up_messages.dart';

class LocalPushService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // LocalPushService 인스턴스 생성을 위한 Singleton 패턴
  static final LocalPushService _instance = LocalPushService._internal();
  static CheerUpMessages cheerUpMessages = CheerUpMessages();

  factory LocalPushService() {
    return _instance;
  }

  LocalPushService._internal();

  Future<void> init() async {
    // Android 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
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

      await androidImplementation?.requestNotificationsPermission();
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
    const NotificationDetails notificationDetails = NotificationDetails(
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

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String subtitle,
    required DateTime startDate,
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      startDate.year,
      startDate.month,
      startDate.day,
      hour,
      minute,
    );
    DateTime now = DateTime.now();
    // DateTime에서 요일은 1(월요일)부터 7(일요일)까지
    int currentWeekday = now.weekday;
    for (final int day in daysOfWeek) {
      int difference = day - currentWeekday;
      if (difference < 0) {
        // 현재 요일 이후에 해당 요일이 오려면 다음 주로 넘기기
        difference += 7;
      }
      final tz.TZDateTime scheduledDateWithDay = scheduledDate.add(Duration(
        days: difference,
      ));

      final int notificationId = id + day;

      DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        subtitle: subtitle,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          id.toString(),
          id.toString(),
          channelDescription: title,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: darwinNotificationDetails,
      );

      var body = cheerUpMessages.getRandomMessage();
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDateWithDay,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '$id',
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
