import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, String> timeZoneMapping = {
    // Common offsets in Asia
    '+08':
        'Asia/Singapore', // Singapore Time (SGT), Malaysia Time (MYT), China Standard Time (CST)
    '+07': 'Asia/Bangkok', // Indochina Time (ICT) - Thailand, Vietnam
    '+05:30': 'Asia/Kolkata', // India Standard Time (IST)
    '+09': 'Asia/Tokyo', // Japan Standard Time (JST)
    '+10': 'Australia/Sydney', // Australian Eastern Standard Time (AEST)

    // Common offsets globally
    'UTC': 'UTC',
    'GMT': 'Etc/GMT',
    '+00': 'Etc/UTC',
    '-05': 'America/New_York', // Eastern Time (ET)
    '-06': 'America/Chicago', // Central Time (CT)
    '-07': 'America/Denver', // Mountain Time (MT)
    '-08': 'America/Los_Angeles', // Pacific Time (PT)

    // Named timezones (just in case)
    'SGT': 'Asia/Singapore',
    'HKT': 'Asia/Hong_Kong',
    'PST': 'America/Los_Angeles',
    'EST': 'America/New_York',
    'CST':
        'Asia/Shanghai', // China Standard Time (careful - also used in US Central Time)
    'JST': 'Asia/Tokyo',
    'KST': 'Asia/Seoul',
    'IST': 'Asia/Kolkata', // India Standard Time
    'MYT': 'Asia/Kuala_Lumpur',

    // Special cases (sometimes devices give these)
    'Asia/Singapore': 'Asia/Singapore', // Pass-through if it's already correct
    'Asia/Kuala_Lumpur': 'Asia/Kuala_Lumpur',
    'Asia/Shanghai': 'Asia/Shanghai',
  };

  String mapTimeZone(String timeZoneNameOrOffset) {
    return timeZoneMapping[timeZoneNameOrOffset] ?? 'UTC';
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
    final String localTimeZone = DateTime.now().timeZoneName;
    final String olsonTimeZone = mapTimeZone(localTimeZone);
    tz.setLocalLocation(tz.getLocation(olsonTimeZone));
  }

  Future<void> scheduleDailyNotifications() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Define target times in order
    final List<TimeOfDay> targetTimes = [
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 15, minute: 0),
      TimeOfDay(hour: 17, minute: 0),
      TimeOfDay(hour: 22, minute: 0),
    ];

    for (int i = 0; i < targetTimes.length; i++) {
      final TimeOfDay targetTime = targetTimes[i];
      final tz.TZDateTime scheduledDate = _nextInstanceOfTime(now, targetTime);

      await _notificationsPlugin.zonedSchedule(
        i, // Unique ID for each time slot
        'Medication Reminder',
        'It\'s time to take your medication.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel', // Same channel for all these notifications
            'Daily Medication Reminder',
            channelDescription: 'Reminds you to take your medications on time',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Helper function to find the next occurrence of a specific time
  tz.TZDateTime _nextInstanceOfTime(tz.TZDateTime now, TimeOfDay time) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      // If the time has already passed today, move to tomorrow
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }
}
