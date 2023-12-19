import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/notifications_alerts_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/circle_image.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsAlerts extends StatefulWidget {
  const NotificationsAlerts({Key? key}) : super(key: key);

  @override
  State<NotificationsAlerts> createState() => _NotificationsAlertsState();
}

class _NotificationsAlertsState extends State<NotificationsAlerts> {
  var controller = Get.put(NotificationsAlertsModel());
  String ePass = 'E-Pass';

  @override
  void initState() {
    super.initState();
    controller.fetchData();
    controller.refreshOnNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: TitleText(
            title: controller.fromDashboard
                ? AppStrings.notifications
                : AppStrings.alerts,
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
          actions: [
            if (controller.fromDashboard)
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.trNotificationSettings);
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.settings,
                    color: AppColors.blueDark,
                  ),
                ),
              ),
          ],
        ),
        body: Obx(() => controller.processing.value
            ? Utils.showProgress()
            : controller.data.isEmpty
                ? Utils.showCenterMessage(AppStrings.noDataFound)
                : RefreshIndicator(
                    onRefresh: () => controller.fromDashboard
                        ? controller.getData()
                        : controller.getAlerts(),
                    child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: ListView.builder(
                            itemCount: controller.data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    if (controller.data[index].typeName ==
                                        ePass) {
                                      Get.toNamed(Routes.passDetail,
                                          arguments: [
                                            controller.data[index].typeId
                                          ]);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: AppColors.moreGrayLight,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const CommonCircleImage(
                                            height: 50,
                                            width: 50,
                                            icon: Images.user,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    140,
                                                child: Text(
                                                    controller.data[index].title
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.blueDark,
                                                        // fontWeight: FontWeight.w600,
                                                        fontSize: 15)),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    140,
                                                child: Text(
                                                  controller.data[index].message
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                Utils.formatDateTime(controller
                                                    .data[index].entryDate
                                                    .toString()),
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                  color: AppColors.grayDark,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            })),
                  )));
  }
}
