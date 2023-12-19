import 'dart:async';
import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/models/all_models/passes_list_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/status_buttons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassDetailModel extends GetxController {
  var stPassesListDataModel = PassesListModel(id: 0);
  List<ValueTextModel> journeyTimeList = <ValueTextModel>[].obs;
  late Rx<Duration> remainingTime = const Duration(seconds: 00).obs;
  late Timer timer;

  RxBool processing = true.obs;
  RxBool sendingUpdate = false.obs;
  RxBool journeyTimeError = false.obs;
  RxBool ePassTimeError = false.obs;
  RxBool showJourneyDropDown = false.obs;
  RxBool startTimer = false.obs;

  ValueTextModel journeyTime =
      ValueTextModel(value: 0, text: '', selected: false);
  ValueTextModel ePassTime =
      ValueTextModel(value: 0, text: '', selected: false);

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  RxString statusText = ''.obs;

  RxString startsAtTime = ''.obs;
  RxString timerTypeStr = ''.obs;
  RxString timerText = ''.obs;

  void refreshOnNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      if (Get.currentRoute == Routes.passDetail) {
        getData();
      }
    });
  }

  Future<void> getTimeData() async {
    await repository.getTimeData().then((value) async {
      journeyTimeList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      journeyTimeUiValidation();
      setJourneyTime();
    }).onError((error, stackTrace) {});
  }

  void setJourneyTime() {
    journeyTime = ValueTextModel(value: 0, text: '', selected: false);
    if ((stPassesListDataModel.journeyTimeId != null &&
            stPassesListDataModel.journeyTimeId != 0) ||
        (stPassesListDataModel.ePassTimeId != null &&
            stPassesListDataModel.ePassTimeId != 0)) {
      for (int i = 0; i < journeyTimeList.length; i++) {
        if (stPassesListDataModel.journeyTimeId == journeyTimeList[i].value) {
          journeyTime = journeyTimeList[i];
        }
        if (stPassesListDataModel.ePassTimeId == journeyTimeList[i].value) {
          ePassTime = journeyTimeList[i];
        }
      }
    }
  }

  Future<void> getData() async {
    await repository.getPassById(await Get.arguments[0]).then((value) async {
      processing.value = true;
      processing.value = false;
      stPassesListDataModel =
          (value as List).map((i) => PassesListModel.fromJson(i)).toList()[0];
      if (stPassesListDataModel.status == 2) {
        statusText.value =
            '${AppStrings.currentlyWaitingForApproval} E-Pass For ${isLocation(stPassesListDataModel.destinationLocationId) ? '${stPassesListDataModel.destinationLocationName.toString()} ${stPassesListDataModel.destinationTeacherName.toString() != 'null' ? '(${stPassesListDataModel.destinationTeacherName.toString()})' : ''}' : stPassesListDataModel.destinationTeacherName.toString()}\nAT (${Utils.formatDateTime(stPassesListDataModel.outTime.toString())})';
      } else {
        statusText.value =
            'E-Pass For ${stPassesListDataModel.destinationLocationName.toString()} AT (${Utils.formatDateTime(stPassesListDataModel.outTime.toString())})';
      }
      setPassData();
      getTimeData();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getData());
      } else {
        processing.value = false;
      }
    });
  }

  void setPassData() {
    if (stPassesListDataModel.status == 3 ||
        stPassesListDataModel.status == 7 ||
        stPassesListDataModel.status == 1) {
      _startTimer();
    }
  }

  Future<void> postApproval() async {
    journeyTimeError.value = false;
    ePassTimeError.value = false;
    if (approveValidated()) {
      sendingUpdate.value = true;
      await repository
          .postApproval(
              '?id=${stPassesListDataModel.id}&JourneyTimeId=${journeyTime.value}'
              '&ePassTimeId=${ePassTime.value}')
          .then((value) async {
        sendingUpdate.value = false;
        getData();
        utils.successMessage(AppStrings.passApproved);
      }).onError((error, stackTrace) async {
        if (Utils.needToken(error!)) {
          await repository.tokenRefreshApi().then((value) => postApproval());
        } else {
          sendingUpdate.value = false;
        }
      });
    }
  }

  Future<void> postDeparted() async {
    String journeyTimeS = '';
    if (journeyValidated(journeyTimeS)) {
      sendingUpdate.value = true;
      await repository.postDeparted('?id=$stPassesListDataModel.id$journeyTimeS').then((value) async {
        sendingUpdate.value = false;
        getData();
        utils.successMessage(AppStrings.passDeparted);
      }).onError((error, stackTrace) async {
        if (Utils.needToken(error!)) {
          await repository.tokenRefreshApi().then((value) => postDeparted());
        } else {
          sendingUpdate.value = false;
        }
      });
    }
  }

  Future<void> postRejection() async {
    sendingUpdate.value = true;
    await repository
        .postRejection('?id=${stPassesListDataModel.id}')
        .then((value) async {
      sendingUpdate.value = false;
      getData();
      utils.successMessage(AppStrings.passRejected);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => postRejection());
      } else {
        sendingUpdate.value = false;
      }
    });
  }

  Future<void> postEnd(id) async {
    sendingUpdate.value = true;
    await repository.postEnd('?id=$id').then((value) async {
      sendingUpdate.value = false;
      getData();
      utils.successMessage(AppStrings.passCompleted);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => postEnd(id));
      } else {
        sendingUpdate.value = false;
      }
    });
  }

  Future<void> postReceived(id) async {
    String ePassTime = '';
    if (stPassesListDataModel.ePassTimeId != null) {
      ePassTime = '&ePassTimeId=${stPassesListDataModel.ePassTimeId}';
    }
    sendingUpdate.value = true;
    await repository.postReceived('?id=$id$ePassTime').then((value) async {
      sendingUpdate.value = false;
      getData();
      utils.successMessage(AppStrings.passReceived);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => postReceived(id));
      } else {
        sendingUpdate.value = false;
      }
    });
  }

  void _startTimer() {
    DateTime dateTime = DateTime.now();
    DateTime dateTimeFrom = DateTime.now();
    try {
      timer.cancel();
    } catch (e) {
      Utils.print(e.toString());
    }
    if ((stPassesListDataModel.destinationTeacherId == 0 ||
            stPassesListDataModel.destinationTeacherId == null) &&
        (stPassesListDataModel.status == PassesStatus.departed ||
            stPassesListDataModel.status == PassesStatus.approved)) {
      timerTypeStr.value = AppStrings.returnWithin;

      if (stPassesListDataModel.status == PassesStatus.approved) {
        startsAtTime.value =
            '${AppStrings.yourJourneyStartsAt} ${Utils.formatTime(stPassesListDataModel.outTime.toString(), true)}';
      } else {
        if (DateTime.parse(stPassesListDataModel.outTime!)
            .isBefore(DateTime.parse(stPassesListDataModel.departedTime!))) {
          dateTimeFrom = DateTime.parse(stPassesListDataModel.departedTime!);
          dateTime = DateTime.parse(stPassesListDataModel.departedTime!).add(
              Duration(
                  minutes: (int.parse(
                      stPassesListDataModel.ePassTime!.split(' ')[0]))));
        } else {
          dateTimeFrom = DateTime.parse(stPassesListDataModel.outTime!);
          dateTime = DateTime.parse(stPassesListDataModel.outTime!).add(
              Duration(
                  minutes: (int.parse(
                      stPassesListDataModel.ePassTime!.split(' ')[0]))));
        }
        startsAtTime.value =
            '${AppStrings.yourJourneyStartsAt} ${Utils.formatTime(stPassesListDataModel.outTime.toString(), true)}';
      }
    } else {
      timerTypeStr.value = AppStrings.returnWithin;

      if (stPassesListDataModel.status == 3) {
        if (DateTime.parse(stPassesListDataModel.outTime!)
            .isBefore(DateTime.parse(stPassesListDataModel.approvedTime!))) {
          dateTimeFrom = DateTime.parse(stPassesListDataModel.approvedTime!);
          dateTime = DateTime.parse(stPassesListDataModel.approvedTime!).add(
              Duration(
                  minutes: (int.parse(
                      stPassesListDataModel.journeyTime!.split(' ')[0]))));
        } else {
          dateTimeFrom = DateTime.parse(stPassesListDataModel.outTime!);
          dateTime = DateTime.parse(stPassesListDataModel.outTime!).add(
              Duration(
                  minutes: (int.parse(
                      stPassesListDataModel.journeyTime!.split(' ')[0]))));
        }
        startsAtTime.value =
            '${AppStrings.yourJourneyStartsAt} ${Utils.formatTime(stPassesListDataModel.outTime.toString(), true)}';
      } else if (stPassesListDataModel.status == 7) {
        if (stPassesListDataModel.departedBy == PassesStatus.from) {
          timerTypeStr.value = AppStrings.reachOnDestinationWithin;
        } else {
          timerTypeStr.value = AppStrings.returnWithin;
        }
        dateTime = DateTime.parse(stPassesListDataModel.departedTime!).add(
            Duration(
                minutes: (int.parse(
                    stPassesListDataModel.journeyTime!.split(' ')[0]))));
        dateTimeFrom = DateTime.parse(stPassesListDataModel.departedTime!);
        startsAtTime.value =
            '${AppStrings.yourJourneyStartsAt} ${Utils.formatTime(stPassesListDataModel.departedTime.toString(), true)}';
      } else if (stPassesListDataModel.status == 1) {
        timerTypeStr.value = AppStrings.completeWorkWithin;
        dateTime = DateTime.parse(stPassesListDataModel.receivedTime!).add(
            Duration(
                minutes: (int.parse(
                    stPassesListDataModel.ePassTime!.split(' ')[0]))));
        dateTimeFrom = DateTime.parse(stPassesListDataModel.receivedTime!);
        startsAtTime.value =
            '${AppStrings.yourJourneyStartsAt} ${Utils.formatTime(stPassesListDataModel.receivedTime.toString(), true)}';
      }
    }

    remainingTime.value =
        const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
    DateTime utcDateTimeFrom = DateTime.utc(
        dateTimeFrom.year,
        dateTimeFrom.month,
        dateTimeFrom.day,
        dateTimeFrom.hour,
        dateTimeFrom.minute,
        dateTimeFrom.second);
    DateTime utcDateTime = DateTime.utc(dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (utcDateTimeFrom.isBefore(DateTime.now())) {
        startTimer.value = true;
      } else {
        startTimer.value = false;
      }
      remainingTime.value = utcDateTime.toLocal().difference(DateTime.now());
      timerText.value = startTimer.value
          ? "$timerTypeStr\n"
              "${remainingTime.value.inHours.remainder(24).toString().padLeft(2, '0')}"
              "h ${remainingTime.value.inMinutes.remainder(60).toString().padLeft(2, '0')}m "
              "${remainingTime.value.inSeconds.remainder(60).toString().padLeft(2, '0')}s"
          : startsAtTime.value;
      if (remainingTime.value.isNegative) {
        timer.cancel();
        remainingTime.value =
            const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
        startTimer.value = true;
      }
    });
  }

  void journeyTimeUiValidation() {
    if (stPassesListDataModel.departingTeacherId == ApiFilters.userId &&
        stPassesListDataModel.status == PassesStatus.raised) {
      showJourneyDropDown.value = true;
    } else if (stPassesListDataModel.destinationTeacherId ==
            ApiFilters.userId &&
        stPassesListDataModel.status == PassesStatus.received) {
      showJourneyDropDown.value = true;
    } else if (stPassesListDataModel.destinationTeacherId ==
            ApiFilters.userId &&
        (stPassesListDataModel.status == PassesStatus.received ||
            (stPassesListDataModel.status == PassesStatus.alert &&
                stPassesListDataModel.receivedTime != null &&
                stPassesListDataModel.departedBy == PassesStatus.from))) {
      showJourneyDropDown.value = true;
    } else {
      showJourneyDropDown.value = false;
    }
  }

  bool isLocation(id) {
    return id != null && id != 0;
  }

  Widget buttonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ApiFilters.userId == stPassesListDataModel.departingTeacherId &&
            stPassesListDataModel.status == PassesStatus.raised)
          Row(
            children: [
              StatusButtons(
                title: AppStrings.approve,
                onTap: () {
                  if (!sendingUpdate.value) {
                    postApproval();
                  }
                },
                color: AppColors.greenColor,
                icon: AppIcon.approve,
              ),
              const SizedBox(
                width: 5,
              ),
              StatusButtons(
                title: AppStrings.reject,
                onTap: () {
                  if (!sendingUpdate.value) {
                    postRejection();
                  }
                },
                color: AppColors.red,
                icon: AppIcon.rejectIcon,
              ),
            ],
          ),
        if (PrivilegeFirstFlags.canEPassComplete())
          if ((ApiFilters.userId == stPassesListDataModel.departingTeacherId ||
                  UserType.isSchoolOperator()) &&
              ![
                PassesStatus.completed,
                PassesStatus.rejected,
                PassesStatus.raised
              ].contains(stPassesListDataModel.status))
            StatusButtons(
              title: AppStrings.complete,
              onTap: () {
                if (!sendingUpdate.value) {
                  postEnd(stPassesListDataModel.id);
                }
              },
              color: AppColors.green,
              icon: AppIcon.endKeep,
            ),
        if (ApiFilters.userId == stPassesListDataModel.destinationTeacherId &&
            (stPassesListDataModel.destinationTeacherId != null &&
                stPassesListDataModel.destinationTeacherId != 0) &&
            ((((stPassesListDataModel.status == PassesStatus.departed) &&
                        PassesStatus.from ==
                            stPassesListDataModel.departedBy) ||
                    stPassesListDataModel.status == PassesStatus.approved) ||
                (stPassesListDataModel.status == PassesStatus.alert &&
                    stPassesListDataModel.receivedTime == null)))
          StatusButtons(
            title: AppStrings.received,
            onTap: () {
              if (!sendingUpdate.value) {
                postReceived(stPassesListDataModel.id);
              }
            },
            color: AppColors.blue,
            icon: AppIcon.approve,
          ),
        if (stPassesListDataModel.destinationTeacherId == ApiFilters.userId &&
            (stPassesListDataModel.status == PassesStatus.received ||
                (stPassesListDataModel.status == PassesStatus.alert &&
                    stPassesListDataModel.receivedTime != null &&
                    stPassesListDataModel.departedBy == PassesStatus.from)))
          StatusButtons(
            title: AppStrings.sendBack,
            onTap: () {
              if (!sendingUpdate.value) {
                postDeparted();
              }
            },
            color: AppColors.green,
            icon: AppIcon.walkIcon,
          )
      ],
    );
  }

  bool approveValidated() {
    bool v = false;
    if (journeyTime.value == 0 &&
        (stPassesListDataModel.destinationTeacherId != 0 &&
            stPassesListDataModel.destinationTeacherId != null)) {
      journeyTimeError.value = true;
    } else if (ePassTime.value == 0) {
      ePassTimeError.value = true;
    } else {
      v = true;
    }
    return v;
  }

  bool journeyValidated(journeyTimeS) {
    bool v = false;
    if (journeyTime.value != 0) {
      journeyTimeS = '&JourneyTimeId=${journeyTime.value}';
    }
    journeyTimeError.value = false;
    if (journeyTime.value == 0) {
      journeyTimeError.value = true;
    } else {
      v = true;
    }
    return v;
  }
}
