import 'dart:async';

import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordModel extends GetxController {
  final emailController = TextEditingController().obs;

  final focusNode = FocusNode().obs;

  RxBool sendingOtp = false.obs;

  RxBool emailError = false.obs;

  RxString emailMessage = AppStrings.pleaseEnterEmail.obs;
  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  void sendOtp() {
    if (validated()) {
      sendOTP();
    }
  }

  Future<void> sendOTP() async {
    sendingOtp.value = true;
    var request = {
      "email": emailController.value.text,
    };

    await repository.sendOtpForPassword(request).then((value) async {
      sendingOtp.value = false;
      utils.snackBarMessage(AppStrings.successfully,
          'OTP has been sent to ${emailController.value.text}');

      Get.toNamed(Routes.resetPassword,
          arguments: [emailController.value.text]);
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => const ForgotPassword(),
      // ));
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => sendingOtp());
      } else {}

      Utils.print(error.toString());
    });
  }

  bool validated() {
    emailError.value = false;
    bool v = false;
    if (emailController.value.text.isEmpty) {
      emailError.value = true;
      emailMessage.value = AppStrings.pleaseEnterEmail;
    } else if (!Utils.isEmail(emailController.value.text)) {
      emailError.value = true;
      emailMessage.value = AppStrings.pleaseEnterValidEmail;
    } else {
      v = true;
    }
    return v;
  }
}
