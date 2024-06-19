import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeeth_homework.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_home/shivpeethnotic.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_pages/shivpeeth_student/shivpeeth_parentview_attendance.dart';

Future<void> backgroundhandler( RemoteMessage message) async {
  print("Messege Recieved! ${message.notification!.title}");
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static Future<void> initialize() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(backgroundhandler);
      print("Notification Intialized");
    }
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
  }

  void firebaseInitnew(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //              try {
      //   Map<String, dynamic> data = message.data;
      //                   print("initlocalnew");
      //       initLocalNotifications(message,context);
      //      showNotification(data);
      // } catch (e) {
      //   print('Exception: $e');
      // }
      initLocalNotifications(message, context);
      showNotificationnew(message);
    });
  }

  void initLocalNotifications(RemoteMessage message, BuildContext context) async {
    var androidInitializationSettings =
    AndroidInitializationSettings('@drawable/androidlogo');
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSetting =
    InitializationSettings(android: androidInitializationSettings

      //iOS: iosInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        // handle interaction when app is active for android
        handleMessage(context, message);
      },
      // onDidReceiveBackgroundNotificationResponse: (NotificationResponse? response){
      // handleMessage(context, message);  }
    );
  }
  showNotificationnew(RemoteMessage message) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/androidlogo');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse? response) { // Adjusted parameter type

//        handleNotificationResponse(data); // Pass the context here

//   },
// //   onDidReceiveBackgroundNotificationResponse: (NotificationResponse? response){
// // handleNotificationResponse(data); // Pass the context here
// //   }
//     );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel',
      'Very important notification!!',
      description: 'the first notification',
      importance: Importance.max,
    );
    Map<String, dynamic> data = message.data;
    var storedata;
    if (data.length > 0) {
      for (dynamic type in data.keys) {
        storedata = (data[type]);
      }
    }
    final body = json.decode(storedata.toString());
    final String messagenew = body['message'];
    final String title = body['title'];
    final String id = body['id'];

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      messagenew,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }
  void handleMessage(BuildContext context, RemoteMessage message) {
    Map<String, dynamic> data = message.data;
    var storedata;
    if (data.length > 0) {
      for (dynamic type in data.keys) {
        storedata = (data[type]);
      }
    }
    final body = json.decode(storedata.toString());
    print(body['activity']);
    print(body['id']);
    final String id = body['id'];

    if (id == 'notice') {
      if (context != "") {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return WireframeEvents();
          },
        ));
      }
    } else if (id == 'homework') {
      final String activity = body['activity'];

      List<String> separateValues = activity.split(',');
      String value1 = separateValues[0];
      String value2 = separateValues[1];

      if (context != "") {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Wireframehomework(classid: value1, sectionid: value2);
          },
        ));
      }
    } else if (id == "attendence") {
      final String activity = body['activity'];

      List<String> separateValues = activity.split(',');
      String value1 = separateValues[0];
      String value2 = separateValues[1];

      if (context != "") {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Wireframe_student_att(classid: value1, sectionid: value2);
          },
        ));
      }
    }
  }
  Future<void> setupInteractMessage(BuildContext context) async {
    print("helloworld");
    // when app is terminated
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  showNotification(Map<String, dynamic> data) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/androidlogo');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) {
        // Adjusted parameter type

        handleNotificationResponse(data); // Pass the context here
      },
//   onDidReceiveBackgroundNotificationResponse: (NotificationResponse? response){
// handleNotificationResponse(data); // Pass the context here
//   }
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel',
      'Very important notification!!',
      description: 'the first notification',
      importance: Importance.max,
    );
    var storedata;
    if (data.length > 0) {
      for (dynamic type in data.keys) {
        storedata = (data[type]);
      }
    }
    final body = json.decode(storedata.toString());
    final String message = body['message'];
    final String title = body['title'];
    final String id = body['id'];

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }
  void handleNotificationResponse(Map<String, dynamic> data) {
    var storedata;
    if (data.length > 0) {
      for (dynamic type in data.keys) {
        storedata = (data[type]);
      }
    }
    final body = json.decode(storedata.toString());

    final String id = body['id'];

    if (id == 'notice') {
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (context) {
      //     return  WireframeEvents();
      //   },
      // ));
    }
  }
}
