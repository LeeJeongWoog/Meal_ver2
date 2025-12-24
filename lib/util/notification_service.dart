import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static const String _channelId = 'daily_bible_channel';
  static const String _channelName = 'Daily Bible Reminder';
  static const String _channelDesc = '매일 끼니 알림';

  static Future<void> init() async {
    // timezone 초기화
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    // 알림 플러그인 초기화
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);

    // Android 채널 생성
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 권한 요청 (Android 13+ / iOS)
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// 매일 10:00 알림 예약 (이미 있으면 갱신하려면 cancel 후 재등록 권장)
  static Future<void> scheduleDaily10amBible() async {
    await ensureInitialized();

    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(tz.local, now.year, now.month, now.day, 10, 0);

    // 오늘 10시가 이미 지났으면 내일 10시로
    if (next.isBefore(now)) {
      next = next.add(const Duration(days: 1));
    }

    // 기존 예약 갱신
    await _plugin.cancel(7001);

    await _plugin.zonedSchedule(
      7001,
      '끼니 시간이에요 🍽️',
      '오늘의 끼니를 묵상해 볼까요?',
      next,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // 정확히 10시에 울리게 하고 싶으면 exactAllowWhileIdle
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간 반복
    );
  }


  static Future<void> ensureInitialized() async {
    if (_isInitialized) return;
    await init();
    _isInitialized = true;
    debugPrint('[NOTI] init done');
  }
  static Future<void> cancelDaily10amBible() async {
    await _plugin.cancel(7001);
  }
}