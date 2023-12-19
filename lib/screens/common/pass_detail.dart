import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/constants/app_exceptions.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/pass_detail_validations.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/pass_detail_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:cicd/widgets/screen_widgets/pass_detail/pass_detail_alert_box.dart';
import 'package:cicd/widgets/screen_widgets/pass_detail/pass_detail_comment_box.dart';
import 'package:cicd/widgets/screen_widgets/pass_detail/pass_detail_from_to_widget.dart';
import 'package:cicd/widgets/screen_widgets/pass_detail/pass_detail_status_text.dart';
import 'package:cicd/widgets/screen_widgets/pass_detail/teacher_notes_button.dart';
import 'package:cicd/widgets/text_value_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassDetail extends StatefulWidget {
  const PassDetail({Key? key}) : super(key: key);

  @override
  State<PassDetail> createState() => _PassDetailState();
}

class _PassDetailState extends State<PassDetail> {
  var controller = Get.put(PassDetailModel());
  late PassValidations passValidations;

  @override
  void initState() {
    passValidations = PassValidations(controller);
    controller.getData();
    controller.refreshOnNotification();
    super.initState();
  }

  @override
  void dispose() {
    try {
      controller.timer.cancel();
    } on NullException {
      Utils.print(AppStrings.nullDataFound);
    }
    Utils.print('-----------------------------------------Disposed');
    super.dispose();
    Get.delete<PassDetailModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          title: Obx(() => controller.processing.value
              ? Container()
              : TitleText(
                  title: controller.stPassesListDataModel.status ==
                          PassesStatus.raised
                      ? AppStrings.waitingForApproval
                      : PassesStatus.getStatus(
                          controller.stPassesListDataModel.status ?? 0),
                )),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.blueDark,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
        ),
        body: Obx(
          () => controller.processing.value
              ? Utils.showProgress()
              : controller.stPassesListDataModel.id == 0
                  ? Utils.showCenterMessage(AppStrings.noDataFound)
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 50),
                        child: Container(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  width: double.infinity,
                                  child: Card(
                                    color: AppColors.moreGrayLight,
                                    elevation: 20,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PassDetailStatusText(
                                            controller: controller,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                controller.statusText.value,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.blueDark),
                                              )),
                                          if (passValidations.showTimerText())
                                            Obx(() => Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 10,
                                                    bottom: 5),
                                                child: Text(
                                                  controller.timerText.value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: passValidations
                                                          .getTimerTextColor()),
                                                ))),
                                          controller.buttonsWidget(),
                                          if (passValidations
                                              .showJourneyDropDownList())
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextValueDropDown(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                items:
                                                    controller.journeyTimeList,
                                                hint: AppStrings
                                                    .selectJourneyTime,
                                                titleColor: AppColors.blueDark,
                                                borderColor: AppColors.blueDark,
                                                whiteHint: false,
                                                search: false,
                                                selectedValue: (value) {
                                                  controller.journeyTime =
                                                      value;
                                                  controller.processing.value =
                                                      true;
                                                  controller.processing.value =
                                                      false;
                                                  controller.update();
                                                },
                                                title: AppStrings.journeyTime,
                                                isInvalid: controller
                                                    .journeyTimeError.value,
                                                errorText: AppStrings
                                                    .pleaseSelectJourneyTime,
                                                selectedItem:
                                                    controller.journeyTime,
                                                onCancel: () {
                                                  controller.journeyTime =
                                                      ValueTextModel(
                                                          value: 0,
                                                          text: '',
                                                          selected: false);
                                                  controller.processing.value =
                                                      true;
                                                  controller.processing.value =
                                                      false;
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          if (passValidations
                                              .showEPassDropDown())
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: TextValueDropDown(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    100,
                                                items:
                                                    controller.journeyTimeList,
                                                hint:
                                                    AppStrings.selectEPassTime,
                                                titleColor: AppColors.blueDark,
                                                borderColor: AppColors.blueDark,
                                                whiteHint: false,
                                                search: false,
                                                selectedValue: (value) {
                                                  controller.ePassTime = value;
                                                  controller.processing.value =
                                                      true;
                                                  controller.processing.value =
                                                      false;
                                                  controller.update();
                                                },
                                                title: AppStrings.ePassTime,
                                                isInvalid: controller
                                                    .ePassTimeError.value,
                                                errorText: AppStrings
                                                    .pleaseSelectEPassTime,
                                                selectedItem:
                                                    controller.ePassTime,
                                                onCancel: () {
                                                  controller.ePassTime =
                                                      ValueTextModel(
                                                          value: 0,
                                                          text: '',
                                                          selected: false);
                                                  controller.processing.value =
                                                      true;
                                                  controller.processing.value =
                                                      false;
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          if (passValidations.showJourneyTime())
                                            Text(
                                              '${AppStrings.journeyTime} : ${controller.stPassesListDataModel.journeyTime.toString()}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: AppColors.blueDark,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                          if (passValidations.showEPassTime())
                                            Text(
                                              '${AppStrings.ePassTime} : ${controller.stPassesListDataModel.ePassTime.toString()}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: AppColors.blueDark,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                          PassDetailFroToWidget(
                                            controller: controller,
                                            passValidations: passValidations,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (passValidations.showComment())
                                            PassDetailCommentBox(
                                              controller: controller,
                                            ),
                                          if (passValidations.showAlert())
                                            PassDetailAlertBox(onTap: () {
                                              Get.toNamed(
                                                  Routes.trNotifications,
                                                  arguments: [
                                                    controller
                                                        .stPassesListDataModel
                                                        .id
                                                  ]);
                                            }),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (PrivilegeFirstFlags
                                              .canViewEPassCommentList())
                                            TeacherNotesButton(
                                              onTap: () {
                                                Get.toNamed(Routes.comments,
                                                    arguments: [
                                                      controller
                                                          .stPassesListDataModel
                                                          .id
                                                    ]);
                                              },
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  color: AppColors.moreGrayLight,
                                  elevation: 5,
                                  shadowColor: AppColors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: Text(
                                        passValidations.getPassTitleText(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blueDark),
                                      )),
                                ),
                              ],
                            )),
                      ),
                    ),
        ));
  }
}
