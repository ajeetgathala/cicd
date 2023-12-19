import 'dart:io';

import 'package:cicd/firebase_options.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locator();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
      name: 'e-pass', options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Start());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
