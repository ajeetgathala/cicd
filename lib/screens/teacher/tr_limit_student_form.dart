import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_limit_student_form_model.dart';
import 'package:cicd/widgets/common_comment_box.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:cicd/widgets/multi_select_dropdown_box.dart';
import 'package:cicd/widgets/text_value_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/date_time_widget.dart';

class TrLimitStudentForm extends StatefulWidget {
  const TrLimitStudentForm({Key? key}) : super(key: key);

  @override
  State<TrLimitStudentForm> createState() => _TrLimitStudentFormState();
}

class _TrLimitStudentFormState extends State<TrLimitStudentForm> {
  var controller = Get.put(TrLimitStudentFormModel());

  @override
  void initState() {
    controller.getStudentDropDownsData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrLimitStudentFormModel>(builder: (_) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            title: TitleText(
              title: AppStrings.limitStudent,
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
          body: GestureDetector(
              onTap: () {
                controller.selectMulti.value = false;
              },
              child: Obx(() => Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MultiSelectDropdownBox(
                            labelText: AppStrings.for_,
                            isNotingSelected: controller.isNotingSelected(),
                            errorText: AppStrings.pleaseSelectStudents,
                            list: controller.studentsList,
                            onItemRemove: (index) {
                              controller.studentsList[index].selected =
                                  !controller.studentsList[index].selected!;
                              controller.update();
                            },
                            onArrowTap: () {
                              controller.selectMulti.value =
                                  !controller.selectMulti.value;
                            },
                            error: controller.studentError.value,
                            showList: controller.selectMulti.value,
                            searchController: controller.searchController.value,
                            onSearchTextChange: (text) {
                              controller.filterStudents();
                            },
                            isAllSelected: controller.isAllSelected(),
                            onSelectAllCheck: (v) {
                              controller.selectAll.value = v!;
                              if (controller.selectAll.value) {
                                for (int i = 0;
                                    i < controller.studentsList.length;
                                    i++) {
                                  controller.studentsList[i].selected = true;
                                }
                                controller.selectMulti.value = false;
                              } else {
                                for (int i = 0;
                                    i < controller.studentsList.length;
                                    i++) {
                                  controller.studentsList[i].selected = false;
                                }
                              }
                              controller.update();
                            },
                            onListItemSelected: (index) {
                              controller.studentsList[index].selected =
                                  !controller.studentsList[index].selected!;
                              controller.update();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextValueDropDown(
                            items: controller.limitsList,
                            selectedValue: (value) {
                              controller.limit = value;
                              controller.update();
                            },
                            errorText: AppStrings.pleaseSelectLimit,
                            hint: AppStrings.selectLimit,
                            title: AppStrings.limit,
                            isInvalid: controller.limitError.value,
                            selectedItem: controller.limit,
                            onCancel: () {
                              controller.limit = ValueTextModel(
                                  value: -1,
                                  text: '',
                                  type: '',
                                  selected: false);
                              controller.update();
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // margin: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: DateTimeWidget(
                                      // textFieldController: suiteController,
                                      labelTextMain: AppStrings.startDate,
                                      labelText: controller.startDate.value,
                                      hintTextColor: controller.sDateColor,
                                      errorText:
                                          AppStrings.pleaseSelectStartDate,
                                      onTap: () {
                                        controller.selectDate(context, 0);
                                      },
                                      isInvalid:
                                          controller.startDateError.value,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  // margin: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: DateTimeWidget(
                                      // textFieldController: suiteController,
                                      labelTextMain: AppStrings.endDate,
                                      labelText: controller.endDate.value,
                                      hintTextColor: controller.eDateColor,
                                      errorText: AppStrings.pleaseSelectEndDate,
                                      onTap: () {
                                        controller.selectDate(context, 1);
                                      },
                                      isInvalid: controller.entDateError.value,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Get.arguments[0] != 0 &&
                                  controller.selectedRepetition.value != -1
                              ? TextValueDropDown(
                                  items: controller.repetitionList,
                                  hint: AppStrings.selectRepetition,
                                  selectedValue: (value) {
                                    controller.repetition = value;
                                    controller.update();
                                  },
                                  selectedItem: controller.selectedRepetition,
                                  title: AppStrings.repetition,
                                  isInvalid: controller.repetitionError.value,
                                  errorText: AppStrings.pleaseSelectPresets,
                                  onCancel: () {
                                    controller.repetition = ValueTextModel(
                                        value: 0,
                                        text: '',
                                        type: '',
                                        selected: false);
                                    controller.update();
                                  },
                                )
                              : TextValueDropDown(
                                  items: controller.repetitionList,
                                  hint: AppStrings.selectRepetition,
                                  selectedValue: (value) {
                                    controller.repetition = value;
                                    controller.selectedRepetition = value;
                                    controller.update();
                                  },
                                  selectedItem: controller.selectedRepetition,
                                  title: AppStrings.repetition,
                                  isInvalid: controller.repetitionError.value,
                                  errorText: AppStrings.pleaseSelectPresets,
                                  onCancel: () {
                                    controller.repetition = ValueTextModel(
                                        value: 0,
                                        text: '',
                                        type: '',
                                        selected: false);
                                    controller.selectedRepetition =
                                        ValueTextModel(
                                            value: -1,
                                            text: '',
                                            type: '',
                                            selected: false);
                                    controller.update();
                                  },
                                ),
                          CommonCommentBox(
                            labelTextMain: AppStrings.reasonOptional,
                            textFieldController:
                                controller.reasonController.value,
                            errorText: AppStrings.pleaseEnterComment,
                            hint: AppStrings.enterReason,
                            onChanged: (value) {
                              controller.reasonController.value.text = value;
                            },
                            isInvalid: controller.reasonError.value,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CommonButtonWidget(
                            onPressed: () {
                              controller.validations();
                            },
                            buttonText: AppStrings.submit,
                            buttonColor: AppColors.blue,
                            textSize: 18,
                            assetIcon: '',
                          ),
                        ],
                      ),
                    ),
                  ))));
    });
  }
}
