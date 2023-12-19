import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_issue_pass_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_home_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:cicd/widgets/district_dropdown.dart';
import 'package:cicd/widgets/school_dropdown.dart';
import 'package:cicd/widgets/tr_home_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrHome extends StatefulWidget {
  const TrHome({Key? key}) : super(key: key);

  @override
  State<TrHome> createState() => _TrHomeState();
}

class _TrHomeState extends State<TrHome> {
  var controller = Get.put(TrHomeModel());

  @override
  void initState() {
    controller.getDashboardTeacher();
    controller.refreshOnNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() => Container(
            color: AppColors.whiteColor,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
            child: Column(
              key: const Key('homeColumn'),
              children: [
                if (controller.showDistrictDropDown())
                  DistrictDropDown(
                    key: const Key('districtDropdown'),
                    items: controller.districtList,
                    selectedValue: (value) async {
                      controller.districtDataModel = value;
                      ApiFilters.setDistrictId(controller.districtDataModel.id);
                      controller.getSchools();
                      controller.isDistrictSelected.value = true;
                      controller.isSchoolSelected.value = false;
                      await AppSharedPreferences.putInt(
                          AppSharedPreferences.selectedSchool, 0);
                      await AppSharedPreferences.putInt(
                          AppSharedPreferences.selectedDistrict, value.id ?? 0);
                    },
                    selectedItem: controller.districtDataModel,
                    title: AppStrings.district,
                    isInvalid: controller.districtError.value,
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (controller.showSchoolDropDown())
                  controller.schoolList.isNotEmpty
                      ? controller.isDistrictSelected.value ||
                              !UserType.isAdmin()
                          ? SchoolDropDown(
                              key: const Key('schoolDropdown'),
                              items: controller.schoolList,
                              selectedValue: (value) async {
                                controller.schoolDataModel = value;
                                ApiFilters.setSchoolId(
                                    controller.schoolDataModel.id.toString());
                                if (!UserType.isStudent()) {
                                  var passController =
                                      Get.put(TrIssuePassModel());
                                  passController.getStudentDropDown();
                                }
                                controller.getDashboardTeacher();
                                controller.gettingSchools.value = true;
                                controller.gettingSchools.value = false;
                                controller.isSchoolSelected.value = true;
                                controller.update();
                                await AppSharedPreferences.putInt(
                                    AppSharedPreferences.selectedSchool,
                                    value.id ?? 0);
                              },
                              selectedItem: controller.schoolDataModel,
                              title: AppStrings.school,
                              isInvalid: controller.schoolError.value,
                            )
                          : Container()
                      : controller.districtList.isNotEmpty
                          ? Text(AppStrings.noSchools)
                          : Container(),
                const SizedBox(
                  height: 10,
                ),
                if (controller.showResumeDialog())
                  Container(
                      decoration: const BoxDecoration(
                          color: AppColors.greenCardBg,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 20, right: 20),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(Icons.calendar_month,
                                      color: AppColors.whiteColor, size: 17),
                                ),
                                TextSpan(
                                    text:
                                        '${AppStrings.yourOutOfOfficeTime} ${Utils.formatOutTime(controller.dashboardTeacher[0].todayOutOfOffice.toString())}',
                                    style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: CommonButtonWidget(
                              onPressed: () {
                                controller.postResume();
                              },
                              cornerRadius: 5,
                              buttonText: AppStrings.resume,
                              textSize: 15,
                              height: 40,
                              textColor: AppColors.greenCardBg,
                              buttonColor: AppColors.whiteColor,
                              isProcessing: controller.postingResume.value,
                            ),
                          )
                        ],
                      )),
                if (controller.showData())
                  Expanded(
                    key: const Key('homeExpended'),
                    child: controller.refreshData.value
                        ? Container(
                            key: const Key('noDataContainer'),
                          )
                        : ListView.builder(
                            key: const Key('homeList'),
                            itemCount: controller.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TrHomeListItem(
                                    key: Key('item$index'),
                                    onTap: () {
                                      controller.moveTo(index);
                                    },
                                    text: controller.data[index].name,
                                    color: controller.data[index].color,
                                    icon: controller.data[index].icon,
                                    subText: controller.data[index].passCount),
                              );
                            }),
                  ),
              ],
            ),
          )),
    );
  }
}
