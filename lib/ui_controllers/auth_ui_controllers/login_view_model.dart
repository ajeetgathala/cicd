import 'dart:async';

import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/login_response.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../constants/session_keys.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;
  LoginResponse loginResponse = LoginResponse();
  RxBool processing = false.obs;
  RxBool emailError = false.obs;
  RxBool passwordError = false.obs;
  RxBool password = true.obs;

  RxString emailMessage = AppStrings.pleaseEnterEmail.obs;
  RxString passwordMessage = AppStrings.pleaseEnterPassword.obs;

  var loginService = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> loginApi() async {
    if (validated()) {
      processing.value = true;
      var request = {
        "userName": emailController.value.text,
        "password": passwordController.value.text
      };
      await loginService.loginApi(request).then((value) async {
        processing.value = false;
        loginResponse = LoginResponse.fromJson(value);

        await AppSharedPreferences.putInt(
            AppSharedPreferences.id, loginResponse.id!);
        await AppSharedPreferences.putBool(
            AppSharedPreferences.isLoggedIn, true);
        await AppSharedPreferences.putInt(
            AppSharedPreferences.userType, loginResponse.userTypeId!);
        await AppSharedPreferences.putString(
            AppSharedPreferences.token, loginResponse.jwtToken!);

        utils.snackBarMessage(AppStrings.successfully,
            '${AppStrings.loggedInWith} ${loginResponse.firstName} ${loginResponse.lastName}');

        UserType.setUserType(loginResponse.userTypeId);

        Get.offNamed(Routes.dashboard, arguments: [0]);
      }).onError((error, stackTrace) async {
        if (Utils.needToken(error!)) {
          await loginService.tokenRefreshApi().then((value) => loginApi());
        } else {
          processing.value = false;
        }
      });
    }
  }

  bool validated() {
    bool validate = false;
    emailError.value = false;
    passwordError.value = false;
    if (emailController.value.text.isEmpty) {
      emailError.value = true;
      emailMessage.value = AppStrings.pleaseEnterEmail;
    } else if (!Utils.isEmail(emailController.value.text)) {
      emailError.value = true;
      emailMessage.value = AppStrings.pleaseEnterValidEmail;
    } else if (passwordController.value.text.isEmpty) {
      passwordError.value = true;
      passwordMessage.value = AppStrings.pleaseEnterPassword;
    } else {
      validate = true;
    }
    return validate;
  }
}
