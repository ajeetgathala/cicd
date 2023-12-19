import 'dart:io';

import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/firebase/firebase_notifications.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/profile_screen_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/circle_image.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:cicd/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var controller = Get.put(ProfileScreenModel());

  @override
  void initState() {
    // controller.getProfileData();
    FirebaseNotifications().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.processing.value
        ? Utils.showProgress()
        : SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 30,
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        controller.showLogoutDialog(context);
                      },
                      child: Text(
                        AppStrings.logOut,
                        style: const TextStyle(
                          color: AppColors.blueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          children: [
                            CommonCircleImage(
                              icon: Images.user,
                              width: 100,
                              height: 100,
                              url:
                                  controller.profileDataModel.value.imagePath ??
                                      '',
                            ),
                            if (controller.updatingImage.value)
                              Utils.showProgress()
                          ],
                        ),
                      ),
                      if (!controller.updatingImage.value)
                        InkWell(
                          onTap: () {
                            showSelection();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColors.blue,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.black,
                                    blurRadius: 8.0,
                                  ),
                                ],
                                border:
                                    Border.all(color: AppColors.blue, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Image.asset(
                              AppIcon.edit,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (controller.showIdNumber())
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: CommonText(
                        title: AppStrings.studentId,
                        text: controller.profileDataModel.value.studentIdNumber
                            .toString(),
                        errorText: '',
                        isInvalid: false,
                        enabled: false,
                        value: (v) {
                          Utils.print('Text Value = $v');
                        },
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CommonText(
                      title: AppStrings.fullName,
                      text:
                          '${controller.profileDataModel.value.firstName.toString()} '
                          '${controller.profileDataModel.value.lastName.toString()}',
                      errorText: '',
                      isInvalid: false,
                      enabled: false,
                      value: (v) {
                        Utils.print('Text Value = $v');
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CommonText(
                      title: AppStrings.emailAddress,
                      text:
                          controller.profileDataModel.value.userName.toString(),
                      errorText: '',
                      isInvalid: false,
                      enabled: false,
                      value: (v) {
                        Utils.print('Text Value = $v');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
  }

  Future<void> showSelection() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: CommonButtonWidget(
                        onPressed: () async {
                          Get.back();
                          takePicture();
                        },
                        height: 50,
                        buttonText: AppStrings.camera,
                        cornerRadius: 20,
                        buttonColor: AppColors.blue,
                        assetIcon: '',
                        isProcessing: controller.loggingOut.value,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: CommonButtonWidget(
                        onPressed: () async {
                          Get.back();
                          selectImage();
                        },
                        height: 50,
                        buttonText: AppStrings.gallery,
                        cornerRadius: 20,
                        buttonColor: AppColors.blue,
                        assetIcon: '',
                        isProcessing: controller.loggingOut.value,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: CommonButtonWidget(
                        onPressed: () {
                          Get.back();
                        },
                        height: 50,
                        buttonText: AppStrings.cancel,
                        buttonColor: AppColors.red,
                        textColor: AppColors.whiteColor,
                        cornerRadius: 20,
                        assetIcon: '',
                      ),
                    ),
                  ],
                )));
      },
    );
  }

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    controller.image = File(file!.path);
    controller.processing.value = true;
    controller.processing.value = false;
    controller.update();
    if (await controller.image!.exists()) {
      showSelectedImage();
    }
  }

  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    controller.image = File(file!.path);
    controller.processing.value = true;
    controller.processing.value = false;
    controller.update();
    if (await controller.image!.exists()) {
      showSelectedImage();
    }
  }

  Future<void> showSelectedImage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            // title: const Text('AlertDialog Title'),
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Image.file(
                    controller.image!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, exception, stackTrace) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        child: Image.asset(
                          AppIcon.placeHolder,
                          fit: BoxFit.fill,
                          color: AppColors.blueDark,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonButtonWidget(
                        onPressed: () {
                          Get.back();
                        },
                        height: 50,
                        buttonText: AppStrings.cancel,
                        buttonColor: AppColors.red,
                        textColor: AppColors.whiteColor,
                        cornerRadius: 20,
                        assetIcon: '',
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CommonButtonWidget(
                        onPressed: () {
                          controller.updateProfile();
                          Get.back();
                        },
                        height: 50,
                        buttonText: AppStrings.upload,
                        buttonColor: AppColors.blue,
                        textColor: AppColors.whiteColor,
                        cornerRadius: 20,
                        assetIcon: '',
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
