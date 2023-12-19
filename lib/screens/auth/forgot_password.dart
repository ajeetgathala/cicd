import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/ui_controllers/auth_ui_controllers/forgot_password_model.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:cicd/widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final forgotPasswordController = Get.put(ForgotPasswordModel());

  @override
  void initState() {
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
                      height: 250,
                      child: Center(
                        child: Image.asset(
                          AppIcon.forgotPasswordMainIcon,
                          width: 250,
                          height: 250,
                        ),
                      )),
                  Container(
                      margin:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.forgotNPassword,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blueDark),
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.doNotWorryItHappens,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.smallTextGrey),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: CommonTextFieldWidget(
                      textFieldController:
                          forgotPasswordController.emailController.value,
                      labelTextMain: AppStrings.emailCap,
                      labelText: AppStrings.enterYourEmail,
                      errorText: forgotPasswordController.emailMessage.value,
                      isInvalid: forgotPasswordController.emailError.value,
                      validator: (v) {},
                      value: (v) {},
                      key: const Key('emailTextField'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: CommonButtonWidget(
                      onPressed: () {
                        if (!forgotPasswordController.sendingOtp.value) {
                          forgotPasswordController.sendOtp();
                        }
                      },
                      isProcessing: forgotPasswordController.sendingOtp.value,
                      buttonText: AppStrings.continue_,
                      textColor: AppColors.whiteColor,
                      buttonColor: AppColors.blue,
                      key: const Key('sendOtp'),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
