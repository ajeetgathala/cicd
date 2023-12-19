import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/ui_controllers/auth_ui_controllers/login_view_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../router/routes.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/common_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.put(LoginViewModel());

  final formKey = GlobalKey<FormState>();

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
                    child: const Center(
                        child: LogoWidget(
                      height: double.infinity,
                      width: double.infinity,
                    )),
                  ),
                  Container(
                      margin:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.welcomeBack,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blueDark),
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.welcomeBackPleaseEnter,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.blueLight),
                      )),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: CommonTextFieldWidget(
                            textFieldController:
                                controller.emailController.value,
                            focusNode: controller.emailFocusNode.value,
                            labelTextMain: AppStrings.emailCap,
                            labelText: AppStrings.enterYourEmail,
                            errorText: controller.emailMessage.value,
                            isInvalid: controller.emailError.value,
                            validator: (v) {
                              // if (v!.isEmpty) {
                              //   Utils.snackBarMessage('Enter Email');
                              // }
                            },
                            onFiledSubmitted: (value) {
                              Utils.focusChange(
                                  context,
                                  controller.emailFocusNode.value,
                                  controller.passwordFocusNode.value);
                            },
                            value: (v) {
                              Utils.print('Text Value = $v');
                            },
                            key: const Key(
                                'emailTextField'), // Add a unique key here
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: CommonTextFieldWidget(
                            textFieldController:
                                controller.passwordController.value,
                            focusNode: controller.passwordFocusNode.value,
                            labelTextMain: AppStrings.passwordCap,
                            labelText: AppStrings.enterPassword,
                            errorText: controller.passwordMessage.value,
                            isPassword: true,
                            isInvalid: controller.passwordError.value,
                            obscureText: controller.password.value,
                            onEyeClick: () {
                              controller.password.value =
                                  !controller.password.value;
                            },
                            value: (v) {
                              Utils.print('Text Value = $v');
                            },
                            key: const Key(
                                'passwordTextField'), // Add a unique key here
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 16.0),
                        TextButton(
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => const ForgotPassword(),
                            // ));
                            Get.toNamed(Routes.forgotPassword);
                          },
                          child: Text(
                            AppStrings.forgotPassword,
                            style: const TextStyle(color: AppColors.blueLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: CommonButtonWidget(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (!controller.processing.value) {
                            controller.loginApi();
                          }
                        }
                      },
                      buttonText: AppStrings.logIn,
                      isProcessing: controller.processing.value,
                      textColor: AppColors.whiteColor,
                      buttonColor: AppColors.blue,
                      assetIcon: '',
                      key: const Key('loginButton'),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
