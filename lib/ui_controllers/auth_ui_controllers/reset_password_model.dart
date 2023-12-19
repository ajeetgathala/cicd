import 'dart:async';

import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordModel extends GetxController {
  final passwordController = TextEditingController().obs;
  final reEnterPasswordController = TextEditingController().obs;

  final enterPasswordFocusNode = FocusNode().obs;
  final reEnterPasswordFocusNode = FocusNode().obs;

  RxBool processing = false.obs;
  RxBool passwordError1 = false.obs;
  RxBool passwordError2 = false.obs;

  RxBool verifying = false.obs;
  RxString enteredOtp = ''.obs;
  RxString email = ''.obs;
  RxBool otpError = false.obs;
  RxBool showResend = false.obs;
  RxString otpErrorMessage = AppStrings.pleaseEnterOtp.obs;
  RxInt sec = 60.obs;

  RxString passwordMessage1 = AppStrings.pleaseEnterEmail.obs;
  RxString passwordMessage2 = AppStrings.pleaseEnterPassword.obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> resetPassword() async {
    passwordError1.value = false;
    passwordError2.value = false;
    otpError.value = false;
    if (validated()) {
      processing.value = true;
      var request = {
        "email": email.value,
        "otp": enteredOtp.value,
        "newPassword": reEnterPasswordController.value.text
      };

      await repository.resetPassword(request).then((value) async {
        processing.value = false;
        utils.successMessage(AppStrings.passwordChanged);
        Get.offAllNamed(Routes.login);
      }).onError((error, stackTrace) async {
        if (Utils.needToken(error!)) {
          await repository.tokenRefreshApi().then((value) => resetPassword());
        } else {
          processing.value = false;
          Utils.print(error.toString());
        }
      });
    }
  }

  Future<void> sendOTP() async {
    verifying.value = true;
    var request = {
      "email": email.value,
    };

    await repository.sendOtpForPassword(request).then((value) async {
      verifying.value = false;
      utils.snackBarMessage(
          AppStrings.successfully, 'OTP has been sent to ${email.value}');
      startTimer();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => sendOTP());
      } else {
        verifying.value = false;
        utils.snackBarMessage(AppStrings.error, error.toString());
        Utils.print(error.toString());
      }
    });
  }

  void startTimer() {
    showResend.value = false;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec.value == 1) {
        timer.cancel();
        sec.value = 60;
        showResend.value = true;
      } else {
        sec.value--;
      }
    });
  }

  void setData(eMail) {
    email.value = eMail;
    startTimer();
  }

  bool validated() {
    bool v = false;
    if (passwordController.value.text.isEmpty) {
      passwordError1.value = true;
      passwordMessage1.value = AppStrings.pleaseEnterPassword;
    } else if (reEnterPasswordController.value.text.isEmpty) {
      passwordError2.value = true;
      passwordMessage2.value = AppStrings.pleaseConfirmPassword;
    } else if (reEnterPasswordController.value.text !=
        passwordController.value.text) {
      passwordError2.value = true;
      passwordMessage2.value = AppStrings.passwordDidNotMatch;
    } else if (enteredOtp.value.isEmpty) {
      otpError.value = true;
      otpErrorMessage.value = AppStrings.pleaseEnterOtp;
    } else if (enteredOtp.value.length != 4) {
      otpError.value = true;
      otpErrorMessage.value = AppStrings.pleaseEnter4Digit;
    } else {
      v = true;
    }
    return v;
  }
}
