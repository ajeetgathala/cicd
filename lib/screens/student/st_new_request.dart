import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/ui_controllers/student_ui_controllers/st_new_request_model.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:cicd/widgets/common_comment_box.dart';
import 'package:cicd/widgets/date_time_widget.dart';
import 'package:cicd/widgets/value_text_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StNewRequest extends StatefulWidget {
  const StNewRequest({Key? key}) : super(key: key);

  @override
  State<StNewRequest> createState() => _StNewRequestState();
}

class _StNewRequestState extends State<StNewRequest> {
  final controller = Get.put(StNewRequestModel());

  @override
  void initState() {
    controller.getPassLimit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StNewRequestModel>(builder: (_) {
      return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
          child: GestureDetector(
            onTap: () {
              controller.dropdownSetting(4);
            },
            child: SingleChildScrollView(
                child: Obx(
              () => controller.refreshUi.value
                  ? Container()
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (controller.stPassLimit.passLimit != null &&
                            controller.stPassLimit.passLimit != null)
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.blue,
                                border: Border.all(color: AppColors.blueLight),
                              ),
                              child: Text(
                                'Pass limit ${controller.stPassLimit.passUsed}'
                                '/${controller.stPassLimit.passLimit}',
                                style: const TextStyle(
                                    color: AppColors.whiteColor),
                              )),
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
                            controller.filterDropDowns();
                            if (controller.departing.type ==
                                AppStrings.teacher) {
                              controller.teacherDeparting = ValueTextModel(
                                  value: -2,
                                  text: '',
                                  type: '',
                                  selected: false);
                            }
                            controller.update();
                            controller.departingSelect.value = false;
                          },
                          errorText: AppStrings.pleaseSelectDepartingFrom,
                          hint: AppStrings.searchForLocationTeacher,
                          title: AppStrings.departingFrom,
                          isInvalid: controller.departError.value,
                          selectedItem: controller.departing,
                          onCancel: () {
                            controller.departing = ValueTextModel(
                                value: 0, text: '', type: '', selected: false);
                            controller.checkLocationTeachers(context);
                            controller.filterDropDowns();
                            if (controller.departing.type ==
                                AppStrings.teacher) {
                              controller.teacherDeparting = ValueTextModel(
                                  value: -2,
                                  text: '',
                                  type: '',
                                  selected: false);
                            }
                            controller.update();
                            controller.departingSelect.value = false;
                          },
                        ),
                        if (controller.departing.type == AppStrings.location)
                          const SizedBox(
                            height: 20,
                          ),
                        if (controller.departing.type == AppStrings.location)
                          ValueTextDropDown(
                            onTap: (a) {
                              controller
                                  .dropdownSetting(controller.departTeacher);
                              controller.departingTeacherSelect.value = !a;
                            },
                            select: controller.departingTeacherSelect.value,
                            items: controller.teacherDepartingList,
                            selectedValue: (value) {
                              controller.teacherDeparting = value;
                              controller.departingTeacherSelect.value = false;
                              controller.checkLocationTeachers(context);
                              controller.filterDropDowns();
                              controller.update();
                            },
                            errorText: AppStrings.pleaseSelectTeacher,
                            hint: AppStrings.selectTeacher,
                            title: AppStrings.fromTeacher,
                            isInvalid: controller.teacherFromError.value,
                            selectedItem: controller.teacherDeparting,
                            onCancel: () {
                              controller.teacherDeparting = ValueTextModel(
                                  value: -2,
                                  text: '',
                                  type: '',
                                  selected: false);
                              controller.departingTeacherSelect.value = false;
                              controller.checkLocationTeachers(context);

                              controller.filterDropDowns();
                              controller.update();
                            },
                          ),
                        const SizedBox(
                          height: 20,
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
                            controller.destinationSelect.value = false;
                            controller.checkLocationTeachers(context);

                            controller.filterDropDowns();
                            controller.update();
                          },
                          errorText: AppStrings.pleaseSelectDestination,
                          hint: AppStrings.searchForLocationTeacher,
                          title: AppStrings.destination,
                          isInvalid: false,
                          selectedItem: controller.destination,
                          onCancel: () {
                            controller.destination = ValueTextModel(
                                value: -1, text: '', selected: false);
                            controller.destinationSelect.value = false;
                            controller.checkLocationTeachers(context);

                            controller.filterDropDowns();
                            controller.update();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ValueTextDropDown(
                          onTap: (a) {
                            controller
                                .dropdownSetting(controller.destinTeacher);
                            controller.destinationTeacherSelect.value = !a;
                          },
                          items: controller.teacherDestinationList,
                          selectedValue: (value) {
                            controller.teacherDestination = value;
                            controller.checkLocationTeachers(context);

                            controller.destinationTeacherSelect.value = false;
                            controller.filterDropDowns();
                            controller.update();
                          },
                          select: controller.destinationTeacherSelect.value,
                          errorText:
                              AppStrings.pleaseSelectDestinationOrToTeacher,
                          hint: AppStrings.selectTeacher,
                          title: AppStrings.toTeacher,
                          isInvalid: controller.teacherToError.value,
                          selectedItem: controller.teacherDestination,
                          onCancel: () {
                            controller.teacherDestination = ValueTextModel(
                                value: -3, text: '', type: '', selected: false);
                            controller.checkLocationTeachers(context);

                            controller.destinationTeacherSelect.value = false;
                            controller.filterDropDowns();
                            controller.update();
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: DateTimeWidget(
                            labelTextMain: AppStrings.time,
                            labelText: controller.selectedTime.value,
                            hintTextColor: controller.selectedTime.value ==
                                    AppStrings.selectTime
                                ? AppColors.gray
                                : AppColors.grayDark,
                            errorText: AppStrings.pleaseSelectTime,
                            onTap: () {
                              controller.selectTime(context);
                            },
                            isInvalid: controller.timeError.value,
                          ),
                        ),
                        CommonCommentBox(
                          textFieldController:
                              controller.commentController.value,
                          errorText: AppStrings.pleaseEnterComment,
                          onChanged: (value) {
                            controller.comment!.value = value;
                          },
                          focusNode: controller.commentFocus.value,
                          isInvalid: controller.commentError.value,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30, bottom: 200),
                          child: CommonButtonWidget(
                            onPressed: () {
                              controller.commentFocus.value.unfocus();
                              if (!controller.processing.value) {
                                if (controller.checkLocationTeachers(context)) {
                                  controller.postRequest();
                                }
                              }
                            },
                            buttonText: AppStrings.submit,
                            buttonColor: AppColors.blue,
                            textSize: 15,
                            isProcessing: controller.processing.value,
                            assetIcon: '',
                          ),
                        )
                      ],
                    ),
            )),
          ));
    });
  }
}
