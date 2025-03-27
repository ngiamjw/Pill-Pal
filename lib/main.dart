import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testing_pill_pal/auth/auth.dart';
import 'package:testing_pill_pal/auth/login_or_register.dart';
import 'package:testing_pill_pal/classes/global_variables.dart';
import 'package:testing_pill_pal/firebase_options.dart';
import 'package:testing_pill_pal/pages/page_view.dart';
import 'package:testing_pill_pal/providers/user_provider.dart';
import 'package:testing_pill_pal/services/firebase.dart';
import 'package:testing_pill_pal/services/notification_service.dart';
import 'package:testing_pill_pal/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer' as developer;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
final FirestoreService firestoreService = FirestoreService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // tz.initializeTimeZones(); // <- Important!
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final notificationService = NotificationService();
  // await notificationService.init();
  // await notificationService.scheduleDailyNotifications();

  Workmanager().initialize(callbackDispatcher);
  await Workmanager().cancelByUniqueName('daily_reminder_task');

  Workmanager().registerPeriodicTask(
    'daily_reminder_task', // Unique Task ID
    'send_daily_notification',
    frequency: Duration(hours: 1), // Interval
    initialDelay: Duration(seconds: 5), // Initial delay to start at 12 PM
  );
  runApp(MultiProvider(providers: [
    //theme provider
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => CounterModel()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: AuthPage());
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final now = DateTime.now();
    if (now.hour != 0) {
      // Skip if it's not exactly midnight
      return Future.value(true); // Success even though we skipped
    }

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? 'no-email';

    if (email == 'no-email') {
      return Future.value(false);
    }
    await firestoreService.resetMedicationStatus(email);
    return Future.value(true); // Return true to indicate successful execution
  });
}
