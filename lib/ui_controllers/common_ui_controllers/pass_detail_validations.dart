import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:flutter/material.dart';

class PassValidations {
  final dynamic controller;

  PassValidations(this.controller);

  bool showButtons() {
    bool show = false;
    if (ApiFilters.userId ==
            controller.stPassesListDataModel.departingTeacherId &&
        controller.stPassesListDataModel.status == PassesStatus.raised) {
      show = true;
    } else if (ApiFilters.userId ==
        controller.stPassesListDataModel.destinationTeacherId) {
      if (controller.stPassesListDataModel.status == PassesStatus.received ||
          (controller.stPassesListDataModel.status == PassesStatus.departed &&
              PassesStatus.from ==
                  controller.stPassesListDataModel.departedBy) ||
          controller.stPassesListDataModel.status == PassesStatus.approved ||
          (ApiFilters.userId ==
                  controller.stPassesListDataModel.destinationTeacherId &&
              PassesStatus.alert == controller.stPassesListDataModel.status &&
              controller.stPassesListDataModel.departedBy ==
                  PassesStatus.from)) {
        show = true;
      }
    } else if (PrivilegeFirstFlags.canEPassComplete() &&
        ((ApiFilters.userId ==
                    controller.stPassesListDataModel.departingTeacherId ||
                UserType.isSchoolOperator()) &&
            ![
              PassesStatus.completed,
              PassesStatus.rejected,
              PassesStatus.raised
            ].contains(controller.stPassesListDataModel.status))) {
      show = true;
    }
    return show;
  }

  bool showTimerText() {
    return controller.stPassesListDataModel.status == PassesStatus.approved ||
        controller.stPassesListDataModel.status == PassesStatus.departed ||
        controller.stPassesListDataModel.status == PassesStatus.received;
  }

  bool showJourneyDropDownList() {
    return controller.showJourneyDropDown.value &&
        (controller.stPassesListDataModel.destinationTeacherId != 0 &&
            controller.stPassesListDataModel.destinationTeacherId != null);
  }

  bool showEPassDropDown() {
    return controller.stPassesListDataModel.status == 2 &&
        controller.stPassesListDataModel.departingTeacherId ==
            ApiFilters.userId;
  }

  bool showJourneyTime() {
    return (controller.stPassesListDataModel.status == PassesStatus.departed ||
            controller.stPassesListDataModel.status == PassesStatus.approved) &&
        (controller.stPassesListDataModel.journeyTimeId != null &&
            controller.stPassesListDataModel.journeyTimeId != 0);
  }

  bool showEPassTime() {
    return controller.stPassesListDataModel.status == PassesStatus.received ||
        controller.stPassesListDataModel.status == PassesStatus.departed ||
        controller.stPassesListDataModel.status == PassesStatus.approved &&
            (controller.stPassesListDataModel.ePassTimeId != null &&
                controller.stPassesListDataModel.ePassTimeId != 0);
  }

  bool showFromSubTitle() {
    return controller
            .isLocation(controller.stPassesListDataModel.departingLocationId) &&
        controller.stPassesListDataModel.departingTeacherName != null;
  }

  bool showToSubTitle() {
    return controller.isLocation(
            controller.stPassesListDataModel.destinationLocationId) &&
        controller.stPassesListDataModel.destinationTeacherName != null;
  }

  bool showComment() {
    return controller.stPassesListDataModel.comment.toString() != '';
  }

  bool showAlert() {
    return controller.stPassesListDataModel.status == 4 &&
        [
          controller.stPassesListDataModel.departingTeacherId,
          controller.stPassesListDataModel.destinationTeacherId
        ].contains(ApiFilters.userId);
  }

  Color getTimerTextColor() {
    return controller.remainingTime.value.inSeconds != 0 ||
            !controller.startTimer.value
        ? AppColors.blueDark
        : AppColors.red;
  }

  String getFromIcon() {
    return controller
            .isLocation(controller.stPassesListDataModel.departingLocationId)
        ? AppIcon.officePng
        : Images.user;
  }

  String getFromImage() {
    return controller
            .isLocation(controller.stPassesListDataModel.departingLocationId)
        ? controller.stPassesListDataModel.departingLocationImage ?? ''
        : controller.stPassesListDataModel.departingTeacherImage ?? '';
  }

  String getFromText() {
    return controller
            .isLocation(controller.stPassesListDataModel.departingLocationId)
        ? controller.stPassesListDataModel.departingLocationName.toString()
        : controller.stPassesListDataModel.departingTeacherName.toString();
  }

  String getToIcon() {
    return controller
            .isLocation(controller.stPassesListDataModel.destinationLocationId)
        ? AppIcon.officePng
        : Images.user;
  }

  String getToImage() {
    return controller
            .isLocation(controller.stPassesListDataModel.destinationLocationId)
        ? controller.stPassesListDataModel.destinationLocationImage ?? ''
        : controller.stPassesListDataModel.destinationTeacherImage ?? '';
  }

  String getToText() {
    return controller
            .isLocation(controller.stPassesListDataModel.destinationLocationId)
        ? controller.stPassesListDataModel.destinationLocationName.toString()
        : controller.stPassesListDataModel.destinationTeacherName.toString();
  }

  String getPassTitleText() {
    return UserType.isStudent()
        ? AppStrings.yourPass
        : '${controller.stPassesListDataModel.studentName}${AppStrings.sPass}';
  }
}
