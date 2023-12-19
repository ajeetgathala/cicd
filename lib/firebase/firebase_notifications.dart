import 'dart:io';

import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title,
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseNotifications {
  static String typeEPass = 'E-Pass';

  void init(BuildContext context) async {
    if (Platform.isIOS) iosPermission();

    const InitializationSettings initSettings = InitializationSettings(
        android: AndroidInitializationSettings("@drawable/launch_background"),
        iOS: DarwinInitializationSettings());

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      Utils.print(
          "Notification Data ------------ ${message.notification!.title} :- ${message.notification!.body}"
          "\n------------------------MessageData---------------------"
          "-----${message.data["TypeId"]} :- ${message.data["TypeName"]}");

      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        if (SessionKeys.inForeground) {
          await Utils.showCustomNotification(message);
        } else {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              '${notification.body} ${message.contentAvailable}',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  importance: Importance.max,
                  priority: Priority.high,
                  icon: android.smallIcon,
                ),
              ));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Utils.print(
          "message--------------------------------notification clicked");
      if (typeEPass == message.data["TypeName"]) {
        Get.toNamed(Routes.passDetail, arguments: [message.data["TypeId"]]);
      }
    });
  }

  void iosPermission() {
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings)
    // {
    //   Utils.print("Settings registered: $settings");
    // });
  }
}
