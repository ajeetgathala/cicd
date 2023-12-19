import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_issue_pass_model.dart';
import 'package:cicd/widgets/common_comment_box.dart';
import 'package:cicd/widgets/value_text_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/date_time_widget.dart';

class TrNewPass extends StatefulWidget {
  const TrNewPass({Key? key}) : super(key: key);

  @override
  State<TrNewPass> createState() => _TrNewPassState();
}

class _TrNewPassState extends State<TrNewPass> {
  var controller = Get.put(TrIssuePassModel());

  @override
  void initState() {
    setTeacher();
    controller.getTimeData();
    super.initState();
  }

  Future<void> setTeacher() async {
    if (UserType.isTeacher()) {
      controller.teacherDeparting = ValueTextModel(
          value: await AppSharedPreferences.getInt(AppSharedPreferences.id),
          text: 'Teacher',
          type: '',
          selected: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrIssuePassModel>(builder: (_) {
      return Obx(() => Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
          child: GestureDetector(
            onTap: () {
              controller.dropdownSetting(7);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ValueTextDropDown(
                    onTap: (a) {
                      controller.dropdownSetting(controller.stSelect);
                      controller.studentSelect.value = !a;
                    },
                    select: controller.studentSelect.value,
                    items: controller.studentsList,
                    selectedValue: (value) {
                      controller.studentSelect.value = false;
                      controller.student = value;
                      controller.update();
                    },
                    hint: AppStrings.selectStudent,
                    selectedItem: controller.student,
                    title: AppStrings.student,
                    errorText: AppStrings.pleaseSelectStudent,
                    isInvalid: controller.studentError.value,
                    onCancel: () {
                      controller.studentSelect.value = false;
                      controller.student =
                          ValueTextModel(value: 0, text: '', selected: false);
                      controller.update();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueTextDropDown(
                    onTap: (a) {
                      controller.dropdownSetting(controller.depart);
                      controller.departingSelect.value = !a;
                    },
                    select: controller.departingSelect.value,
                    items: controller.departingList,
                    selectedValue: (value) {
                      controller.departing = value;
                      controller.checkLocationTeachers(context);
                      controller.departingSelect.value = false;
                      if (!UserType.isTeacher() &&
                          controller.departing.type == AppStrings.teacher) {
                        controller.teacherDeparting = ValueTextModel(
                            value: -2, text: '', type: '', selected: false);
                      }
                      controller.update();
                      controller.setFilterDropDownData();
                    },
                    hint: AppStrings.selectLocationTeacher,
                    selectedItem: controller.departing,
                    title: AppStrings.departingFrom,
                    errorText: AppStrings.pleaseSelectDepartingFrom,
                    isInvalid: controller.departingError.value,
                    onCancel: () {
                      controller.departing = ValueTextModel(
                          value: 0, text: '', type: '', selected: false);
                      controller.checkLocationTeachers(context);
                      controller.departingSelect.value = false;
                      if (!UserType.isTeacher() &&
                          controller.departing.type == AppStrings.teacher) {
                        controller.teacherDeparting = ValueTextModel(
                            value: -2, text: '', type: '', selected: false);
                      }
                      controller.update();
                      controller.setFilterDropDownData();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (controller.showDepartTeacherDropDown())
                    Column(
                      children: [
                        ValueTextDropDown(
                          onTap: (a) {
                            controller
                                .dropdownSetting(controller.departTeacher);
                            controller.departingTeacherSelect.value = !a;
                          },
                          select: controller.departingTeacherSelect.value,
                          items: controller.teacherListDeparting,
                          selectedValue: (value) {
                            controller.departingTeacherSelect.value = false;
                            controller.teacherDeparting = value;
                            controller.checkLocationTeachers(context);
                            controller.update();
                            controller.setFilterDropDownData();
                          },
                          errorText: AppStrings.pleaseSelectTeacher,
                          hint: AppStrings.selectTeacher,
                          title: AppStrings.fromTeacher,
                          isInvalid: controller.teacherDepartingError.value,
                          selectedItem: controller.teacherDeparting,
                          onCancel: () {
                            controller.departingTeacherSelect.value = false;
                            controller.teacherDeparting = ValueTextModel(
                                value: -2, text: '', type: '', selected: false);
                            controller.checkLocationTeachers(context);
                            controller.update();
                            controller.setFilterDropDownData();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ValueTextDropDown(
                    onTap: (a) {
                      controller.dropdownSetting(controller.destin);
                      controller.destinationSelect.value = !a;
                    },
                    select: controller.destinationSelect.value,
                    items: controller.destinationList,
                    selectedValue: (value) {
                      controller.destination = value;
                      controller.checkLocationTeachers(context);
                      controller.destinationSelect.value = false;
                      controller.update();
                      controller.setFilterDropDownData();
                    },
                    errorText: AppStrings.pleaseSelectDestination,
                    hint: AppStrings.selectLocationTeacher,
                    title: AppStrings.destination,
                    selectedItem: controller.destination,
                    isInvalid: false,
                    onCancel: () {
                      controller.destination =
                          ValueTextModel(value: -1, text: '', selected: false);
                      controller.checkLocationTeachers(context);
                      controller.destinationSelect.value = false;
                      controller.update();
                      controller.setFilterDropDownData();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueTextDropDown(
                    onTap: (a) {
                      controller.dropdownSetting(controller.destinTeacher);
                      controller.destinationTeacherSelect.value = !a;
                    },
                    select: controller.destinationTeacherSelect.value,
                    items: controller.teacherListDestination,
                    selectedValue: (value) {
                      controller.teacherDestination = value;
                      controller.checkLocationTeachers(context);
                      controller.destinationTeacherSelect.value = false;
                      controller.update();
                      controller.setFilterDropDownData();
                    },
                    errorText: AppStrings.pleaseSelectDestinationOrToTeacher,
                    hint: AppStrings.selectTeacher,
                    title: AppStrings.toTeacher,
                    isInvalid: controller.teacherDestinationError.value,
                    selectedItem: controller.teacherDestination,
                    onCancel: () {
                      controller.teacherDestination = ValueTextModel(
                          value: -3, text: '', type: '', selected: false);
                      controller.checkLocationTeachers(context);
                      controller.destinationTeacherSelect.value = false;
                      controller.update();
                      controller.setFilterDropDownData();
                    },
                  ),
                  if (controller.teacherDestination.value != -3)
                    const SizedBox(
                      height: 20,
                    ),
                  if (controller.teacherDestination.value != -3)
                    ValueTextDropDown(
                      onTap: (a) {
                        controller.dropdownSetting(controller.jourTimeSelect);
                        controller.journeySelect.value = !a;
                      },
                      select: controller.journeySelect.value,
                      items: controller.journeyTimeList,
                      selectedValue: (value) {
                        controller.journeyTime = value;
                        controller.journeySelect.value = false;
                        controller.update();
                      },
                      errorText: AppStrings.pleaseSelectJourneyTime,
                      hint: AppStrings.selectJourneyTime,
                      title: AppStrings.journeyTime,
                      isInvalid: controller.journeyTimeError.value,
                      selectedItem: controller.journeyTime,
                      onCancel: () {
                        controller.journeyTime =
                            ValueTextModel(value: 0, text: '', selected: false);
                        controller.journeySelect.value = false;
                        controller.update();
                      },
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueTextDropDown(
                    onTap: (a) {
                      controller.dropdownSetting(controller.passTimeSelect);
                      controller.ePassSelect.value = !a;
                    },
                    select: controller.ePassSelect.value,
                    items: controller.journeyTimeList,
                    selectedValue: (value) {
                      controller.ePassSelect.value = false;
                      controller.ePassTime = value;
                      controller.update();
                    },
                    errorText: AppStrings.pleaseSelectEPassTime,
                    hint: AppStrings.selectEPassTime,
                    title: AppStrings.ePassTime,
                    isInvalid: controller.ePassTimeError.value,
                    selectedItem: controller.ePassTime,
                    onCancel: () {
                      controller.ePassSelect.value = false;
                      controller.ePassTime =
                          ValueTextModel(value: 0, text: '', selected: false);
                      controller.update();
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: DateTimeWidget(
                      // textFieldController: suiteController,
                      labelTextMain: AppStrings.time,
                      labelText: controller.selectedTime.value,
                      hintTextColor: controller.timeColor,
                      errorText: AppStrings.pleaseSelectTime,
                      onTap: () {
                        controller.selectTime(context);
                      },
                      isInvalid: controller.timeError.value,
                    ),
                  ),
                  CommonCommentBox(
                    textFieldController: controller.commentController.value,
                    errorText: AppStrings.pleaseEnterComment,
                    onChanged: (value) {
                      controller.commentController.value.text = value;
                    },
                    focusNode: controller.commentFocus.value,
                    isInvalid: controller.commentError.value,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 200),
                    child: CommonButtonWidget(
                      onPressed: () {
                        controller.commentFocus.value.unfocus();
                        if (!controller.processing.value) {
                          if (controller.checkLocationTeachers(context)) {
                            controller.validate();
                          }
                        }
                      },
                      buttonText: AppStrings.submit,
                      buttonColor: AppColors.blue,
                      textSize: 15,
                      isProcessing: controller.processing.value,
                      assetIcon: '',
                    ),
                  ),
                ],
              ),
            ),
          )));
    });
  }
}
