import 'dart:io';

import 'package:cicd/app_flags/constraint_permissions.dart';
import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/app_flags/second_privilege.dart';
import 'package:cicd/app_flags/third_privilege.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/firebase/fcm_token.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/all_models/profile_data_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/ui_controllers/student_ui_controllers/st_new_request_model.dart';
import 'package:cicd/ui_controllers/student_ui_controllers/st_passes_list_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_issue_pass_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_home_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreenModel extends GetxController {
  var profileDataModel = ProfileDataModel().obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  File? image = File('');

  RxBool processing = true.obs;
  RxBool loggingOut = false.obs;

  RxBool updatingImage = false.obs;

  Future<void> getProfileData() async {
    // processing.value = true;
    await repository
        .getProfile(await AppSharedPreferences.getInt(AppSharedPreferences.id))
        .then((value) async {
      processing.value = false;
      profileDataModel.value = ProfileDataModel.fromJson(value);

      setFcmToken();

      ApiFilters.setDistrictId(profileDataModel.value.districtId);
      ApiFilters.setSchoolId(profileDataModel.value.schoolIdArr.toString());
      ApiFilters.setUserId(profileDataModel.value.id);
      SessionKeys.ePassTime = profileDataModel.value.ePassMaxTime ?? '';

      ConstraintFlags.permissions = profileDataModel.value.permission!;
      PrivilegeFirstFlags.privilegeFirst =
          profileDataModel.value.privilegeFirst!;
      PrivilegeSecondFlags.secondPrivilege =
          profileDataModel.value.privilegeSecond!;
      PrivilegeThirdFlags.privilegeThird =
          profileDataModel.value.privilegeThird!;

      var homeController = Get.put(TrHomeModel());
      if (UserType.isStudent()) {
        var passController = Get.put(StNewRequestModel());
        var studentPasses = Get.put(StPassesListModel());
        passController.getLocationDropDown();
        studentPasses.getData();
      } else {
        var passController = Get.put(TrIssuePassModel());
        if (UserType.isAdmin()) {
          homeController.getDistricts();
        } else if (UserType.isDistrictAdmin()) {
          homeController.getSchools();
        } else {
          homeController.getDashboardTeacher();
        }
        passController.getStudentDropDown();
      }
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getProfileData());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> postToken(id, token) async {
    String savedToken =
        await AppSharedPreferences.getString(AppSharedPreferences.fcmToken) ??
            '';
    if (savedToken != token || savedToken != '') {
      var request = {"userId": id, "registrationToken": token};
      await repository.postFcmToken(request).then((value) async {
        Utils.print('Post Token Response ----------------- $value');
      }).onError((error, stackTrace) async {
        if (Utils.needToken(error!)) {
          await repository
              .tokenRefreshApi()
              .then((value) => postToken(id, token));
        }
      });
    } else {
      Utils.print('Token matched ----------------------- ');
    }
  }

  Future<void> updateProfile() async {
    updatingImage.value = true;
    await repository
        .updateProfile(
            await AppSharedPreferences.getInt(AppSharedPreferences.id), image)
        .then((value) async {
      getProfileData();
      utils.successMessage(AppStrings.profileUpdatedSuccessfully);
      updatingImage.value = false;
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => updateProfile());
      } else {
        updatingImage.value = false;
      }
    });
  }

  Future<void> logout() async {
    loggingOut.value = true;
    update();
    // repository.stopTimer();
    await repository.getLogout().then((value) async {
      loggingOut.value = false;
      Get.back();
      await AppSharedPreferences.clearPreferences();
      Get.offAllNamed(Routes.login);
      utils.successMessage(AppStrings.loggedOut);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => logout());
      } else {
        loggingOut.value = false;
      }
    });
  }

  Future<void> setFcmToken() async {
    if (Utils.isDate30DaysOld(DateTime.parse(
        await AppSharedPreferences.getString(
                AppSharedPreferences.fcmTokenDate) ??
            DateTime.now().subtract(const Duration(days: 30)).toString()))) {
      String fcmToken = await FCMToken.getFcm();
      Utils.print('FCM TOKEN ----------------------------- $fcmToken');
      await AppSharedPreferences.putString(
          AppSharedPreferences.fcmToken, fcmToken);
      await AppSharedPreferences.putString(
          AppSharedPreferences.fcmTokenDate, DateTime.now().toString());
      postToken(profileDataModel.value.id, fcmToken);
    }
  }

  Future<void> showLogoutDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    AppIcon.logOut,
                    width: 80,
                    height: 80,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.logOutQ,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blueDark),
                    )),
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.areYouSureYouWantToLogout,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.blueLight),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 20, right: 5),
                          child: CommonButtonWidget(
                            onPressed: () {
                              Get.back();
                            },
                            height: 50,
                            buttonText: AppStrings.close,
                            buttonColor: AppColors.moreGrayLight,
                            textColor: AppColors.gray,
                            cornerRadius: 20,
                            assetIcon: '',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 5, right: 20),
                          child: CommonButtonWidget(
                            onPressed: () async {
                              logout();
                            },
                            height: 50,
                            buttonText: AppStrings.logout,
                            cornerRadius: 20,
                            buttonColor: AppColors.blue,
                            assetIcon: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }

  bool showIdNumber() {
    return UserType.isStudent() &&
        profileDataModel.value.studentIdNumber.toString().trim() != "" &&
        profileDataModel.value.studentIdNumber.toString() != 'null';
  }
}
