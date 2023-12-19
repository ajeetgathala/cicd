import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/ui_controllers/auth_ui_controllers/reset_password_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../constants/app_colors.dart';
import '../../constants/const_assets.dart';
import '../../utils/utils.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/common_text_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final resetPasswordController = Get.put(ResetPasswordModel());

  @override
  void initState() {
    resetPasswordController.setData(Get.arguments[0] ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60),
        color: AppColors.whiteColor,
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  height: 200,
                  child: Center(
                    child: Image.asset(
                      AppIcon.forgotPasswordMainIcon,
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.resetPassword,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blueDark,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.pleaseEnterYourNewPassword,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.smallTextGrey,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: CommonTextFieldWidget(
                    textFieldController:
                        resetPasswordController.passwordController.value,
                    focusNode:
                        resetPasswordController.enterPasswordFocusNode.value,
                    labelTextMain: AppStrings.enterNewPasswordCap,
                    labelText: AppStrings.enterYourNewPassword,
                    errorText: resetPasswordController.passwordMessage1.value,
                    isInvalid: resetPasswordController.passwordError1.value,
                    onFiledSubmitted: (value) {
                      Utils.focusChange(
                        context,
                        resetPasswordController.enterPasswordFocusNode.value,
                        resetPasswordController.reEnterPasswordFocusNode.value,
                      );
                    },
                    value: (v) {
                      Utils.print('Text Value = $v');
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: CommonTextFieldWidget(
                    textFieldController:
                        resetPasswordController.reEnterPasswordController.value,
                    labelTextMain: AppStrings.confirmNewPasswordCap,
                    focusNode:
                        resetPasswordController.reEnterPasswordFocusNode.value,
                    labelText: AppStrings.confirmYourNewPassword,
                    errorText: resetPasswordController.passwordMessage2.value,
                    isInvalid: resetPasswordController.passwordError2.value,
                    value: (v) {},
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: AppStrings.enterTheOtpSentTo,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.smallTextGrey,
                          ),
                        ),
                        TextSpan(
                          text: resetPasswordController.email.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.blueDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                OTPTextField(
                  length: 4,
                  spaceBetween: 20,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: AppColors.moreGrayLight,
                  ),
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 45,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  textFieldAlignment: MainAxisAlignment.center,
                  fieldStyle: FieldStyle.box,
                  onChanged: (v) {
                    resetPasswordController.enteredOtp.value = v;
                    Utils.print("Entered: $v");
                  },
                ),
                if (!resetPasswordController.showResend.value)
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      '00:${resetPasswordController.sec.value.toString().padLeft(2, '0')} Seconds',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueDark,
                      ),
                    ),
                  ),
                if (resetPasswordController.otpError.value)
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      resetPasswordController.otpErrorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                if (resetPasswordController.showResend.value)
                  Container(
                    key: const Key('resendButton'),
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.doNotReceiveCode,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.smallTextGrey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (!resetPasswordController.verifying.value) {
                              if (resetPasswordController.showResend.value) {
                                resetPasswordController.sendOTP();
                              }
                            }
                          },
                          child: Text(
                            AppStrings.reSend,
                            style: TextStyle(
                              fontSize: 14,
                              color: resetPasswordController.showResend.value
                                  ? AppColors.blue
                                  : AppColors.grayLight,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: CommonButtonWidget(
                    onPressed: () {
                      resetPasswordController.resetPassword();
                    },
                    buttonText: AppStrings.submit,
                    buttonColor: AppColors.blue,
                    isProcessing: resetPasswordController.processing.value ||
                        resetPasswordController.verifying.value,
                    assetIcon: '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
