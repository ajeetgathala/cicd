import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_contact_control_form_model.dart';
import 'package:cicd/widgets/common_comment_box.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:cicd/widgets/multi_select_dropdown_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/date_time_widget.dart';

class TrContactControlForm extends StatefulWidget {
  const TrContactControlForm({Key? key}) : super(key: key);

  @override
  State<TrContactControlForm> createState() => _TrContactControlFormState();
}

class _TrContactControlFormState extends State<TrContactControlForm> {
  var controller = Get.put(TrContactControlFromModel());

  @override
  void initState() {
    controller.getStudentDropDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrContactControlFromModel>(builder: (_) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            title: TitleText(
              title: AppStrings.contactControl,
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
                controller.selectMulti1.value = false;
              },
              child: mainWidget()));
    });
  }

  Widget mainWidget() {
    return Obx(() => Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                getStudentMultiDropDown(),
                const SizedBox(
                  height: 20,
                ),
                getLocationMultiDropDown(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.cardGray,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    children: [
                      DateTimeWidget(
                        // textFieldController: suiteController,
                        labelTextMain: AppStrings.expirationDate,
                        labelText: controller.selectedDate.value,
                        errorText: AppStrings.pleaseSelectExpiryDate,
                        hintTextColor: controller.dateColor,
                        onTap: () {
                          controller.selectDate(context);
                        },
                        isInvalid: controller.expiryError.value,
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
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                CommonCommentBox(
                  labelTextMain: AppStrings.adminOnlyNoteOptional,
                  textFieldController: controller.adminController.value,
                  errorText: AppStrings.pleaseEnterComment,
                  hint: AppStrings.enterNote,
                  onChanged: (value) {
                    controller.adminController.value.text = value;
                  },
                  isInvalid: controller.adminError.value,
                ),
                const SizedBox(
                  height: 50,
                ),
                CommonButtonWidget(
                  onPressed: () {
                    controller.validations();
                  },
                  buttonText: AppStrings.submit,
                  buttonColor: AppColors.blue,
                  textSize: 18,
                  isProcessing: controller.processing.value,
                  assetIcon: '',
                ),
              ],
            ),
          ),
        ));
  }

  Widget getStudentMultiDropDown() {
    return MultiSelectDropdownBox(
      labelText: AppStrings.student,
      isNotingSelected: controller.isNotingSelected(),
      errorText: AppStrings.pleaseSelectStudents,
      list: controller.studentsList,
      onItemRemove: (index) {
        controller.studentsList[index].selected =
            !controller.studentsList[index].selected!;
        controller.update();
      },
      onArrowTap: () {
        controller.selectMulti.value = !controller.selectMulti.value;
      },
      error: controller.studentError.value,
      showList: controller.selectMulti.value,
      searchController: controller.searchControllerSt.value,
      onSearchTextChange: (text) {
        controller.filterStudents();
      },
      isAllSelected: controller.isAllSelected(),
      onSelectAllCheck: (v) {
        controller.selectAll.value = v!;
        if (controller.selectAll.value) {
          for (int i = 0; i < controller.studentsList.length; i++) {
            controller.studentsList[i].selected = true;
          }
          controller.selectMulti.value = false;
        } else {
          for (int i = 0; i < controller.studentsList.length; i++) {
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
    );
  }

  Widget getLocationMultiDropDown() {
    return MultiSelectDropdownBox(
      labelText: AppStrings.location,
      isNotingSelected: controller.isLocationNotingSelected(),
      errorText: AppStrings.pleaseSelectLocations,
      list: controller.locationsList,
      onItemRemove: (index) {
        controller.locationsList[index].selected =
            !controller.locationsList[index].selected!;
        controller.update();
      },
      onArrowTap: () {
        controller.selectMulti1.value = !controller.selectMulti1.value;
      },
      error: controller.locationError.value,
      showList: controller.selectMulti1.value,
      searchController: controller.searchControllerL.value,
      onSearchTextChange: (text) {
        controller.filterLocations();
      },
      isAllSelected: controller.isLocationAllSelected(),
      onSelectAllCheck: (v) {
        controller.selectAll1.value = v!;
        if (controller.selectAll1.value) {
          for (int i = 0; i < controller.locationsList.length; i++) {
            controller.locationsList[i].selected = true;
          }
          controller.selectMulti1.value = false;
        } else {
          for (int i = 0; i < controller.locationsList.length; i++) {
            controller.locationsList[i].selected = false;
          }
        }
        controller.update();
      },
      onListItemSelected: (index) {
        controller.locationsList[index].selected =
            !controller.locationsList[index].selected!;
        controller.update();
      },
    );
  }
}
