import 'package:firebase_messaging/firebase_messaging.dart';

abstract class FCMToken {
  static Future<String> getFcm() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token ?? '';
  }
}
