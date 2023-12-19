import 'dart:async';

import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/all_models/st_pass_limit_data_model.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/dashboard_model.dart';
import 'package:cicd/ui_controllers/student_ui_controllers/st_passes_list_model.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_strings.dart';

class StNewRequestModel extends GetxController {
  int depart = 0;
  int destin = 1;
  int departTeacher = 2;
  int destinTeacher = 3;

  RxBool departingSelect = false.obs;
  RxBool destinationSelect = false.obs;
  RxBool departingTeacherSelect = false.obs;
  RxBool destinationTeacherSelect = false.obs;

  final commentController = TextEditingController().obs;
  final commentFocus = FocusNode().obs;
  ValueTextModel departing =
      ValueTextModel(value: 0, text: '', type: '', selected: false);
  ValueTextModel destination =
      ValueTextModel(value: -1, text: '', selected: false);
  ValueTextModel teacherDeparting =
      ValueTextModel(value: -2, text: '', type: '', selected: false);
  ValueTextModel teacherDestination =
      ValueTextModel(value: -3, text: '', type: '', selected: false);

  List<ValueTextModel> allList = <ValueTextModel>[].obs;
  List<ValueTextModel> departingList = <ValueTextModel>[].obs;
  List<ValueTextModel> teacherDepartingList = <ValueTextModel>[].obs;
  List<ValueTextModel> teacherDestinationList = <ValueTextModel>[].obs;
  List<ValueTextModel> destinationList = <ValueTextModel>[].obs;
  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  var stPassLimit = StPassLimitDataModel();

  RxString selectedDate =
      Utils.formatDate(DateTime.now().toString(), false).obs;
  RxString selectedTime =
      Utils.formatTime(DateTime.now().toString(), false).obs;
  var selectedTimeDate = DateTime.now().obs;
  RxString selectedDateApi = Utils.formatDateApiLocal(DateTime.now()).obs;
  RxString selectedTimeApi = Utils.formatTimeApiLocal(DateTime.now()).obs;

  Color dateColor = AppColors.grayDark;
  Color timeColor = AppColors.grayDark;

  RxString? comment = ''.obs;

  RxBool departError = false.obs;
  RxBool dateError = false.obs;
  RxBool timeError = false.obs;
  RxBool commentError = false.obs;
  RxBool teacherFromError = false.obs;
  RxBool teacherToError = false.obs;

  RxBool processing = false.obs;
  RxBool refreshUi = false.obs;

  void postRequest() {
    departError.value = false;
    dateError.value = false;
    timeError.value = false;
    commentError.value = false;
    teacherFromError.value = false;
    teacherToError.value = false;
    if (departing.type == AppStrings.location &&
        teacherDeparting.text!.isEmpty) {
      teacherFromError.value = true;
    } else if (departing.text!.isEmpty) {
      departError.value = true;
    } else if (destination.text!.isEmpty && teacherDestination.text!.isEmpty) {
      teacherToError.value = true;
    } else if (selectedDateApi.value == AppStrings.selectDate) {
      dateError.value = true;
    } else if (selectedTimeApi.value == AppStrings.selectTime) {
      timeError.value = true;
    } else {
      if (Utils.isPreviousTime(selectedTimeDate.value)) {
        selectedDate.value = Utils.formatDate(DateTime.now().toString(), false);
        selectedTime.value = Utils.formatTime(DateTime.now().toString(), false);
        selectedDateApi.value = Utils.formatDateApiLocal(DateTime.now());
        selectedTimeApi.value = Utils.formatTimeApiLocal(DateTime.now());
        selectedTimeDate.value = DateTime.now();
      }
      requestPass();
    }
  }

  Future<void> requestPass() async {
    var request = {
      "studentId": await AppSharedPreferences.getInt(AppSharedPreferences.id),
      "departingLocationId":
          departing.type == AppStrings.teacher ? 0 : departing.value,
      "departingTeacherId": teacherDeparting.value == -2
          ? departing.value
          : teacherDeparting.value,
      "destinationTeacherId":
          teacherDestination.value == -3 ? 0 : teacherDestination.value,
      "destinationLocationId": destination.value == -1 ? 0 : destination.value,
      "outTime": Utils.formatDateTimeApi(
          DateTime.parse('${selectedDateApi.value} ${selectedTimeApi.value}')),
      "comment": commentController.value.text,
      "ePassTimeId": destination.value == -1 ? 0 : destination.ePassExpiredTime
    };
    processing.value = true;
    await repository.requestNewPass(request).then((value) async {
      processing.value = false;
      refreshUi.value = true;
      refreshUi.value = false;
      setData();
      var dashController = Get.put(DashboardModel());
      dashController.getToHome();
      var homeController = Get.put(StPassesListModel());
      homeController.getData();
      utils.successMessage(AppStrings.passIsRequested);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => requestPass());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getLocationDropDown() async {
    await repository.getTeacherLocationsDropDown().then((value) async {
      allList = (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      departingList = (value).map((i) => ValueTextModel.fromJson(i)).toList();
      setDropdownData();
      update();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getLocationDropDown());
      }
    });
  }

  void setDropdownData() {
    teacherDepartingList.clear();
    teacherDestinationList.clear();
    destinationList.clear();
    for (int i = 0; i < allList.length; i++) {
      if (allList[i].type == AppStrings.teacher) {
        teacherDepartingList.add(allList[i]);
        teacherDestinationList.add(allList[i]);
      } else {
        destinationList.add(allList[i]);
      }
    }
  }

  void filterDropDowns() {
    departingList.clear();
    teacherDepartingList.clear();
    teacherDestinationList.clear();
    destinationList.clear();
    for (int i = 0; i < allList.length; i++) {
      departingList.add(allList[i]);

      if (allList[i].type == AppStrings.teacher) {
        if (departing.type == AppStrings.teacher) {
          if (departing.value != allList[i].value) {
            teacherDestinationList.add(allList[i]);
          }
        } else {
          if (teacherDestination.value != allList[i].value) {
            teacherDepartingList.add(allList[i]);
          }
          if (teacherDeparting.value != allList[i].value) {
            teacherDestinationList.add(allList[i]);
          }
        }
      } else {
        if (departing.type != AppStrings.teacher) {
          if (departing.value != allList[i].value) {
            destinationList.add(allList[i]);
          }
        } else {
          if (teacherDeparting.value != allList[i].value) {
            destinationList.add(allList[i]);
          }
        }
      }
    }
  }

  Future<void> getPassLimit() async {
    await repository.getStPassLimit().then((value) async {
      stPassLimit = StPassLimitDataModel.fromJson(value);
      update();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getPassLimit());
      }
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppColors.blue,
              colorScheme: const ColorScheme.light(primary: AppColors.blue),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });

    if (picked != null) {
      selectedDate.value = Utils.formatDate(picked.toString(), false);
      selectedDateApi.value = picked.toString().split(' ')[0];
      dateColor = AppColors.grayDark;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.blue,
            colorScheme: const ColorScheme.light(primary: AppColors.blue),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );

    if (picked != null) {
      DateTime dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          picked.hour, picked.minute);
      if (Utils.isMoreThanEPassTime(
          dateTime,
          SessionKeys.ePassTime == ''
              ? 120
              : int.parse(SessionKeys.ePassTime.split(' ')[0]))) {
        utils.snackBarMessage(AppStrings.invalidTime,
            '${AppStrings.pleaseSelectTimeBetween} ${SessionKeys.ePassTime == '' ? '2 hours' : SessionKeys.ePassTime}');
        if (!context.mounted) return;
        selectTime(context);
      } else {
        selectedTimeDate.value = dateTime;
        selectedTime.value = Utils.formatTime(dateTime.toString(), false);
        selectedTimeApi.value = dateTime.toString().split(' ')[1];
        timeColor = AppColors.grayDark;
      }
    }
  }

  void setData() {
    setDropdownData();
    departingList = departingList;
    destinationList = destinationList;

    commentController.value.text = '';
    teacherDeparting =
        ValueTextModel(value: -2, text: '', type: '', selected: false);

    selectedDate = Utils.formatDate(DateTime.now().toString(), false).obs;
    selectedTime = Utils.formatTime(DateTime.now().toString(), false).obs;
    selectedDateApi = Utils.formatDateApiLocal(DateTime.now()).obs;
    selectedTimeApi = Utils.formatTimeApiLocal(DateTime.now()).obs;

    selectedTimeDate.value = DateTime.now();
    teacherDestination =
        ValueTextModel(value: -3, text: '', type: '', selected: false);
    departing = ValueTextModel(value: 0, text: '', type: '', selected: false);
    destination = ValueTextModel(value: -1, text: '', selected: false);

    dateColor = AppColors.grayDark;
    timeColor = AppColors.grayDark;

    update();
  }

  bool checkLocationTeachers(context) {
    bool value = false;
    if (teacherDestination.value == teacherDeparting.value) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromTeacherAndDestinationCanNotBeSame);
    } else if (destination.value == departing.value &&
        destination.type == departing.type) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromTeacherAndDestinationCanNotBeSame);
    } else if (departing.type == AppStrings.teacher &&
        departing.value == teacherDestination.value) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromTeacherAndDestinationCanNotBeSame);
    } else {
      value = true;
    }
    return value;
  }

  void dropdownSetting(int id) {
    if (id == 4) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
    } else if (id == 3) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
    } else if (id == 2) {
      departingSelect.value = false;
      destinationSelect.value = false;
      destinationTeacherSelect.value = false;
    } else if (id == 1) {
      departingSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
    } else if (id == 0) {
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
    }
  }
}
