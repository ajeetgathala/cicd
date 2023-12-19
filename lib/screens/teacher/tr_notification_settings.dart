import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_notification_settings_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class TrNotificationSettings extends StatefulWidget {
  const TrNotificationSettings({Key? key}) : super(key: key);

  @override
  State<TrNotificationSettings> createState() => _TrNotificationSettingsState();
}

class _TrNotificationSettingsState extends State<TrNotificationSettings> {
  final controller = Get.put(NotificationSettingsModel());

  @override
  void initState() {
    controller.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: TitleText(
            title: AppStrings.notificationSettings,
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const SizedBox(
                width: 30,
                height: 30,
                child: Icon(Icons.arrow_back),
              )),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.processing.value
              ? Utils.showProgress()
              : Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.allNotifications,
                                  style: const TextStyle(
                                    color: AppColors.blueDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            activeColor: AppColors.blue,
                            inactiveColor: AppColors.grayLight,
                            showOnOff: false,
                            onToggle: (val) {
                              controller.allSwitch.value = val;
                              controller.allSwitchCheck();
                              controller.postSettings();
                            },
                            value: controller.allSwitch.value,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.newPassNotifications,
                              style: const TextStyle(
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            activeColor: AppColors.blue,
                            inactiveColor: AppColors.grayLight,
                            showOnOff: false,
                            onToggle: (val) {
                              controller.newSwitch.value = val;
                              controller.dataCheck();
                              controller.postSettings();
                            },
                            value: controller.newSwitch.value,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.reminderNotifications,
                              style: const TextStyle(
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            activeColor: AppColors.blue,
                            inactiveColor: AppColors.grayLight,
                            showOnOff: false,
                            onToggle: (val) {
                              controller.reminderSwitch.value = val;
                              controller.dataCheck();
                              controller.postSettings();
                            },
                            value: controller.reminderSwitch.value,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.alertNotifications,
                              style: const TextStyle(
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            activeColor: AppColors.blue,
                            inactiveColor: AppColors.grayLight,
                            showOnOff: false,
                            onToggle: (val) {
                              controller.alertSwitch.value = val;
                              controller.dataCheck();
                              controller.postSettings();
                            },
                            value: controller.alertSwitch.value,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.completeNotifications,
                              style: const TextStyle(
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            activeColor: AppColors.blue,
                            inactiveColor: AppColors.grayLight,
                            showOnOff: false,
                            onToggle: (val) {
                              controller.completeSwitch.value = val;
                              controller.dataCheck();
                              controller.postSettings();
                            },
                            value: controller.completeSwitch.value,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              AppStrings.departedNotifications,
                              style: const TextStyle(
                                color: AppColors.blueDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            activeColor: AppColors.blue,
                            inactiveColor: AppColors.grayLight,
                            showOnOff: false,
                            onToggle: (val) {
                              controller.departedSwitch.value = val;
                              controller.dataCheck();
                              controller.postSettings();
                            },
                            value: controller.departedSwitch.value,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        ));
  }
}
