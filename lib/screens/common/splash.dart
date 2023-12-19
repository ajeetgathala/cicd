import 'dart:async';

import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/splash_model.dart';
import 'package:cicd/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../router/routes.dart';

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var controller = Get.put(SplashModel());

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  Future<void> isLogin() async {
    bool loggedIn =
        await AppSharedPreferences.getBool(AppSharedPreferences.isLoggedIn) ??
            false;
    UserType.setUserType(
        await AppSharedPreferences.getInt(AppSharedPreferences.userType));

    if (loggedIn) {
      controller.refreshToken();
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.offNamed(Routes.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: LogoWidget(
          height: 140,
          width: 140,
        ),
      ),
    );
  }
}
