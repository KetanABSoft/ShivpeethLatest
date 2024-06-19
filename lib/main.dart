import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shivpeeth_erp_system/notification_services.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_Authentication/shivpeeth_splash.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeethnotic.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_theme.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_theme/shivpeeth_themecontroller.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_translation/stringtranslation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:convert';
import 'firebase_options.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   await NotificationService.initialize();

  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
 // FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

@pragma('vm:entry-point')
// Future<void> _backgroundMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   try {
//     Map<String, dynamic> data = message.data;
//     notificationServices.showNotification(data);
//   } catch (e) {
//     print('Exception: $e');
//   }
// }

//late NotificationServices notificationServices;
NotificationService notificationServices=NotificationService();
//NotificationService notificationService = NotificationService();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themedata = Get.put(WireframeThemecontroler());

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    try {
      Map<String, dynamic> data = message.data;
      notificationServices.showNotification(data);
      handleNotificationResponse(data);

      //notificationServices.showNotification(message);
    } catch (e) {
      print('Exception: $e');
    }
  }

  void handleNotificationResponse(Map<String, dynamic> data) {
    print('response $data');
    var storedata;
    if (data.length > 0) {
      for (dynamic type in data.keys) {
        storedata = (data[type]);
      }
    }
    final body = json.decode(storedata.toString());

    final String id = body['id'];

    if (id == 'notice') {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return WireframeEvents();
        },
      ));
    }
  }

  @override
  void initState() {
    super.initState();
//notificationServices = NotificationServices(context);
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themedata.isdark
          ? WireframeMythemes.darkTheme
          : WireframeMythemes.lightTheme,
      fallbackLocale: const Locale('en', 'US'),
      translations: WireframeApptranslation(),
      locale: const Locale('en', 'US'),
      home: const WireframeSplash(),
    );
  }
}
