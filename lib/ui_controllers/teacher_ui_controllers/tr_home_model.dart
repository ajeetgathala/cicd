import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/models/all_models/district_data_model.dart';
import 'package:cicd/models/all_models/schools_data_model.dart';
import 'package:cicd/models/all_models/dashboard_data_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_issue_pass_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrHomeModel extends GetxController {
  List<DistrictDataModel> districtList = <DistrictDataModel>[].obs;
  List<SchoolsDataModel> schoolList = <SchoolsDataModel>[].obs;
  List<DashboardDataModel> dashboardTeacher = <DashboardDataModel>[].obs;

  DistrictDataModel districtDataModel = DistrictDataModel(name: '');
  SchoolsDataModel schoolDataModel = SchoolsDataModel(schoolName: '');

  List<ListData> data = [
    ListData(AppStrings.activePasses, AppIcon.activePass, '', AppColors.yellow),
    ListData(
        AppStrings.locationLimit, AppIcon.locationLimit, '', AppColors.orange),
    ListData(AppStrings.outOfOffice, AppIcon.outOfOffice, '', AppColors.pink),
    ListData(AppStrings.limitStudentPasses, AppIcon.limitStudent, '',
        AppColors.greenCardBg),
    ListData(
        AppStrings.contactControl, AppIcon.contactControl, '', AppColors.purple)
  ].obs;

  RxBool postingResume = false.obs;
  RxBool districtError = false.obs;
  RxBool schoolError = false.obs;
  RxBool gettingDistricts = true.obs;
  RxBool gettingSchools = true.obs;
  RxBool hasDashboardTeacherData = false.obs;
  RxBool refreshData = false.obs;
  RxBool isDistrictSelected = false.obs;
  RxBool isSchoolSelected = false.obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  RxBool selectDistrict = false.obs;
  RxBool selectSchool = false.obs;

  Future<void> setDistrict() async {
    int savedId = await AppSharedPreferences.getInt(
            AppSharedPreferences.selectedDistrict) ??
        0;
    districtDataModel = DistrictDataModel(name: AppStrings.selectDistrict);
    for (int i = 0; i < districtList.length; i++) {
      if (districtList[i].id == savedId) {
        districtDataModel = districtList[i];
        ApiFilters.setDistrictId(districtDataModel.id);
        isDistrictSelected.value = true;
        break;
      }
    }
    getSchools();
  }

  void refreshOnNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      if (Get.currentRoute == Routes.dashboard) {
        getDashboardTeacher();
      }
    });
  }

  Future<void> setSchool() async {
    int savedId = await AppSharedPreferences.getInt(
            AppSharedPreferences.selectedSchool) ??
        0;
    schoolDataModel = SchoolsDataModel(schoolName: AppStrings.selectSchool);
    if (schoolList.isNotEmpty) {
      for (int i = 0; i < schoolList.length; i++) {
        if (schoolList[i].id == savedId) {
          schoolDataModel = schoolList[i];
          ApiFilters.setSchoolId(schoolDataModel.id.toString());
          isSchoolSelected.value = true;
          break;
        }
      }
    } else {
      ApiFilters.setSchoolId('');
    }
  }

  Future<void> postResume() async {
    postingResume.value = true;
    await repository.postResume().then((value) async {
      utils.successMessage(AppStrings.resumePosted);
      postingResume.value = false;
      getDashboardTeacher();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => postResume());
      } else {
        postingResume.value = false;
      }
    });
  }

  Future<void> getDistricts() async {
    gettingDistricts.value = true;
    await repository.getDistricts().then((value) async {
      districtList =
          (value as List).map((i) => DistrictDataModel.fromJson(i)).toList();
      setDistrict();
      update();
      gettingDistricts.value = false;
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getDistricts());
      } else {
        gettingDistricts.value = false;
      }
    });
  }

  Future<void> getStatusData() async {
    await repository.getEPassStatus().then((value) async {
      PassesStatus.data =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getStatusData());
      }
    });
  }

  Future<void> getDashboardTeacher() async {
    await repository.getDashboardData().then((value) async {
      dashboardTeacher =
          (value as List).map((i) => DashboardDataModel.fromJson(i)).toList();
      hasDashboardTeacherData.value = dashboardTeacher.isNotEmpty;
      if (hasDashboardTeacherData.value) {
        data = [
          ListData(
              AppStrings.activePasses,
              AppIcon.activePass,
              '${dashboardTeacher[0].totalPass} ${AppStrings.passes}',
              AppColors.yellow),
          ListData(
              AppStrings.locationLimit,
              AppIcon.locationLimit,
              '${dashboardTeacher[0].locationLimit} ${AppStrings.locationLimit}',
              AppColors.orange),
          ListData(
              AppStrings.outOfOffice,
              AppIcon.outOfOffice,
              '${dashboardTeacher[0].outOfOffice} ${AppStrings.outOfOffice}',
              AppColors.pink),
          ListData(
              AppStrings.limitStudentPasses,
              AppIcon.limitStudent,
              '${dashboardTeacher[0].limitStudentPasses} ${AppStrings.limitStudentPasses}',
              AppColors.greenCardBg),
          ListData(
              AppStrings.contactControl,
              AppIcon.contactControl,
              '${dashboardTeacher[0].contactControl} ${AppStrings.contactControl}',
              AppColors.purple)
        ];
        refreshData.value = true;
        refreshData.value = false;
      }
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getDashboardTeacher());
      } else {
        refreshData.value = false;
      }
    });
  }

  Future<void> getSchools() async {
    gettingSchools.value = true;
    await repository.getSchools().then((value) async {
      schoolList =
          (value as List).map((i) => SchoolsDataModel.fromJson(i)).toList();
      setSchool();

      if (!UserType.isStudent()) {
        var passController = Get.put(TrIssuePassModel());
        passController.getStudentDropDown();
      }
      getDashboardTeacher();
      update();
      gettingSchools.value = false;
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getSchools());
      } else {
        gettingSchools.value = false;
      }
    });
  }

  void setFirebaseRefresh() {
    FirebaseMessaging.onMessage.listen((event) async {
      if (Get.currentRoute == Routes.dashboard) {
        getDashboardTeacher();
      }
    });
  }

  bool showDistrictDropDown() {
    return (!gettingDistricts.value && districtList.isNotEmpty) &&
        (UserType.isAdmin());
  }

  bool showSchoolDropDown() {
    return !gettingSchools.value && UserType.isAdmin() ||
        UserType.isDistrictAdmin();
  }

  bool showResumeDialog() {
    return (hasDashboardTeacherData.value) &&
        (dashboardTeacher[0].todayOutOfOffice?.isNotEmpty ?? false) &&
        (UserType.isTeacher());
  }

  bool showData() {
    return isSchoolSelected.value ||
        UserType.isTeacher() ||
        UserType.isSchoolOperator();
  }

  void moveTo(int index) {
    if (index == 0) {
      Get.toNamed(Routes.trPasses, arguments: [data[index].name]);
    } else if (index == 1) {
      Get.toNamed(Routes.trLocationLimitList, arguments: [data[index].name]);
    } else if (index == 2) {
      Get.toNamed(Routes.trOutOfOfficeList);
    } else if (index == 3) {
      Get.toNamed(Routes.trLimitStudent, arguments: [data[index].name]);
    } else if (index == 4) {
      Get.toNamed(Routes.trContactControl);
    }
    Utils.print('Current route: ${Get.currentRoute}');
  }
}

class ListData {
  String name;
  String icon;
  String passCount;
  Color color;

  ListData(this.name, this.icon, this.passCount, this.color);
}
