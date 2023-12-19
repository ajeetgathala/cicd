import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_out_of_office_model.dart';
import 'package:cicd/widgets/common_comment_box.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:cicd/widgets/date_time_widget.dart';
import 'package:cicd/widgets/text_value_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/common_text_field.dart';

class TrOutOfOffice extends StatefulWidget {
  const TrOutOfOffice({Key? key}) : super(key: key);

  @override
  State<TrOutOfOffice> createState() => _TrOutOfOfficeState();
}

class _TrOutOfOfficeState extends State<TrOutOfOffice> {
  var controller = Get.put(TrOutOfOfficeModel());

  @override
  void initState() {
    if (!UserType.isTeacher()) {
      controller.getTeachers();
    } else {
      controller.getPresets();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrOutOfOfficeModel>(builder: (_) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            title: TitleText(
              title: AppStrings.outOfOffice,
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
          body: Obx(() => getWidget()));
    });
  }

  Widget getWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: CommonTextFieldWidget(
                textFieldController: controller.titleController.value,
                labelTextMain: AppStrings.title,
                labelText: AppStrings.enterTitle,
                errorText: AppStrings.pleaseEnterTitle,
                isInvalid: controller.titleError.value,
                enabled: true,
              ),
            ),
            if (!UserType.isTeacher())
              const SizedBox(
                height: 20,
              ),
            if (!UserType.isTeacher())
              TextValueDropDown(
                items: controller.teachersList,
                hint: AppStrings.selectTeacher,
                selectedValue: (value) {
                  controller.teacher = value;
                  controller.update();
                },
                title: AppStrings.teacher,
                isInvalid: controller.teacherError.value,
                errorText: AppStrings.pleaseSelectTeacher,
                selectedItem: controller.teacher,
                onCancel: () {
                  controller.teacher =
                      ValueTextModel(value: 0, text: '', selected: false);
                  controller.update();
                },
              ),
            const SizedBox(
              height: 20,
            ),
            TextValueDropDown(
              items: controller.presetsList,
              hint: AppStrings.selectPresets,
              selectedValue: (value) {
                controller.preset = value;
                controller.update();
              },
              title: AppStrings.presets,
              isInvalid: controller.presetsError.value,
              errorText: AppStrings.pleaseSelectPresets,
              selectedItem: controller.preset,
              onCancel: () {
                controller.preset =
                    ValueTextModel(value: 0, text: '', selected: false);
                controller.update();
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: DateTimeWidget(
                // textFieldController: suiteController,
                labelTextMain: AppStrings.date,
                hintTextColor: controller.dateColor,
                labelText: controller.selectedDate.value,
                errorText: AppStrings.pleaseSelectDate,
                onTap: () {
                  controller.selectDate(context);
                  controller.update();
                },
                isInvalid: controller.dateError.value,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // margin: const EdgeInsets.only(top: 20),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: DateTimeWidget(
                      labelTextMain: AppStrings.startTime,
                      labelText: controller.selectedTime.value,
                      hintTextColor: controller.sTimeColor,
                      errorText: AppStrings.pleaseSelectStartTime,
                      onTap: () {
                        controller.selectTime(context, 0);
                      },
                      isInvalid: controller.startTimeError.value,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: DateTimeWidget(
                      hintTextColor: controller.eTimeColor,
                      labelTextMain: AppStrings.endTime,
                      labelText: controller.selectedTime1.value,
                      errorText: AppStrings.pleaseSelectEndTime,
                      onTap: () {
                        controller.selectTime(context, 1);
                      },
                      isInvalid: controller.endTimeError.value,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextValueDropDown(
              items: controller.repetitionList,
              hint: AppStrings.selectRepetition,
              selectedValue: (value) {
                controller.repetition = value;
                controller.update();
              },
              title: AppStrings.repetition,
              errorText: AppStrings.pleaseSelectRepetition,
              isInvalid: controller.repetitionError.value,
              selectedItem: controller.repetition,
              onCancel: () {
                controller.repetition =
                    ValueTextModel(value: 0, text: '', selected: false);
                controller.update();
              },
            ),
            CommonCommentBox(
              labelTextMain: AppStrings.reasonOptional,
              textFieldController: controller.reasonController.value,
              errorText: AppStrings.pleaseEnterComment,
              hint: AppStrings.enterReason,
              onChanged: (value) {
                controller.reasonController.value.text = value;
              },
              isInvalid: controller.reasonError.value,
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 100),
              child: CommonButtonWidget(
                onPressed: () {
                  controller.validations();
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
      ),
    );
  }
}
