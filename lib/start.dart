import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/style.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'constants/app_strings.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> with WidgetsBindingObserver {
  @override
  void initState() {
    SessionKeys.inForeground = true;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      textDirection: TextDirection.ltr,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      color: AppColors.whiteColor,
      theme: ThemeUtils.appTheme()
      // ThemeData(
      //   primarySwatch: AppColors.colorPrimarySwatch,
      //   fontFamily: AppFontFamily.primaryFont,
      // )
      ,
      initialRoute: Routes.splash,
      getPages: getPages,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        SessionKeys.inForeground = true;
        Utils.print(
            '---------------------------------------App is in the foreground');
        break;
      case AppLifecycleState.inactive:
        // App is in an inactive state (e.g., call or notification)
        Utils.print(
            '---------------------------------------App is in an inactive state');
        break;
      case AppLifecycleState.paused:
        SessionKeys.inForeground = false;
        Utils.print(
            '----------------------------------------App is in the background');
        break;
      case AppLifecycleState.detached:
        // App is detached (not running)
        Utils.print(
            '----------------------------------------App is detached (not running)');
        break;
      case AppLifecycleState.hidden:
        Utils.print(
            '----------------------------------------App is detached (hidden)');
        break;
    }
  }
}
