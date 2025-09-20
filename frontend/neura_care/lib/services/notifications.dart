import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neura_care/models/med.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<bool> checkNotificationPermissions() async {
  // Check basic notification permission
  PermissionStatus notificationStatus = await Permission.notification.status;
  
  // For Android 13+, check if we can schedule exact alarms
  bool canScheduleExactAlarms = true;
  try {
    final plugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (plugin != null) {
      canScheduleExactAlarms = await plugin.canScheduleExactNotifications() ?? false;
    }
  } catch (e) {
    print('Error checking exact alarm permission: $e');
    canScheduleExactAlarms = false;
  }
  
  return notificationStatus.isGranted && canScheduleExactAlarms;
}

Future<bool> requestNotificationPermissions() async {
  try {
    // Request basic notification permission
    PermissionStatus status = await Permission.notification.request();
    
    if (!status.isGranted) {
      return false;
    }
    
    // For Android 13+, request exact alarm permission
    final plugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (plugin != null) {
      final bool? canScheduleExactAlarms = await plugin.canScheduleExactNotifications();
      if (canScheduleExactAlarms == false) {
        // Request exact alarm permission
        await plugin.requestExactAlarmsPermission();
        // Recheck after request
        return await plugin.canScheduleExactNotifications() ?? false;
      }
      return canScheduleExactAlarms ?? true;
    }
    
    return true;
  } catch (e) {
    print('Error requesting notification permissions: $e');
    return false;
  }
}

Future<void> setTimedNotification(Med med) async {
  await initializeNotifications();
  
  // Check permissions first
  bool hasPermissions = await checkNotificationPermissions();
  if (!hasPermissions) {
    throw Exception('Notification permissions not granted. Please enable notifications and exact alarms in settings.');
  }
  
  try {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, med.timingHrs, med.timingMins);
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      med.hashCode,
      'Medication Reminder',
      'Time to take your medication: ${med.medName} (${med.number} tablets)',
      tz.TZDateTime.from(scheduledDate, tz.local).isBefore(tz.TZDateTime.now(tz.local))
          ? tz.TZDateTime.from(scheduledDate.add(const Duration(days: 1)), tz.local)
          : tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel', 
          'Medication Reminders', 
          channelDescription: 'Channel for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: med.medName,
      matchDateTimeComponents: DateTimeComponents.time, 
    );
  print('Notification scheduled for ${med.medName} at ${med.timingHrs}:${med.timingMins}');
  } catch (e) {
    print('Error setting notification: $e');
    if (e.toString().contains('exact_alarms_not_permitted')) {
      throw Exception('Exact alarms permission required. Please grant exact alarms permission in Android settings.');
    } else {
      throw Exception('Error setting notification: $e');
    }
  }
}

Future<void> showImmediateNotification(String title, String body) async {
  await initializeNotifications();
  
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      'immediate_channel',
      'Immediate Notifications',
      channelDescription: 'Channel for immediate notifications',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );
  
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}