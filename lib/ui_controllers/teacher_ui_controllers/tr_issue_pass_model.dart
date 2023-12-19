import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/router/routes.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/dashboard_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrIssuePassModel extends GetxController {
  int depart = 0;
  int destin = 1;
  int departTeacher = 2;
  int destinTeacher = 3;
  int stSelect = 4;
  int jourTimeSelect = 5;
  int passTimeSelect = 6;

  RxBool departingSelect = false.obs;
  RxBool destinationSelect = false.obs;
  RxBool departingTeacherSelect = false.obs;
  RxBool destinationTeacherSelect = false.obs;
  RxBool studentSelect = false.obs;
  RxBool journeySelect = false.obs;
  RxBool ePassSelect = false.obs;

  List<ValueTextModel> allListMain = <ValueTextModel>[].obs;
  List<ValueTextModel> departingList = <ValueTextModel>[].obs;
  List<ValueTextModel> teacherListDeparting = <ValueTextModel>[].obs;
  List<ValueTextModel> destinationList = <ValueTextModel>[].obs;
  List<ValueTextModel> teacherListDestination = <ValueTextModel>[].obs;
  List<ValueTextModel> studentsList = <ValueTextModel>[].obs;
  List<ValueTextModel> journeyTimeList = <ValueTextModel>[].obs;

  RxBool searching = false.obs;
  final searchFocus = FocusNode().obs;

  final commentFocus = FocusNode().obs;

  final commentController = TextEditingController().obs;

  RxString selectedDate =
      Utils.formatDate(DateTime.now().toString(), false).obs;
  RxString selectedTime =
      Utils.formatTime(DateTime.now().toString(), false).obs;
  var selectedTimeDate = DateTime.now().obs;
  RxString selectedDateApi = Utils.formatDateApiLocal(DateTime.now()).obs;
  RxString selectedTimeApi = Utils.formatTimeApiLocal(DateTime.now()).obs;

  ValueTextModel departing =
      ValueTextModel(value: 0, text: '', type: '', selected: false);
  ValueTextModel destination =
      ValueTextModel(value: -1, text: '', selected: false);
  ValueTextModel teacherDeparting =
      ValueTextModel(value: -2, text: '', type: '', selected: false);
  ValueTextModel teacherDestination =
      ValueTextModel(value: -3, text: '', type: '', selected: false);

  ValueTextModel student = ValueTextModel(value: 0, text: '', selected: false);
  ValueTextModel journeyTime =
      ValueTextModel(value: 0, text: '', selected: false);
  ValueTextModel ePassTime =
      ValueTextModel(value: 0, text: '', selected: false);

  Color dateColor = AppColors.grayDark;
  Color timeColor = AppColors.grayDark;

  RxBool studentError = false.obs;
  RxBool departingError = false.obs;
  RxBool teacherDepartingError = false.obs;
  RxBool teacherDestinationError = false.obs;

  // RxBool destinationError = false.obs;
  RxBool dateError = false.obs;
  RxBool timeError = false.obs;
  RxBool commentError = false.obs;
  RxBool journeyTimeError = false.obs;
  RxBool ePassTimeError = false.obs;

  RxBool processing = false.obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> validate() async {
    commentFocus.value.unfocus();
    studentError.value = false;
    departingError.value = false;
    // destinationError.value = false;
    dateError.value = false;
    timeError.value = false;
    commentError.value = false;
    teacherDepartingError.value = false;
    teacherDestinationError.value = false;
    journeyTimeError.value = false;
    ePassTimeError.value = false;

    final fieldsToValidate = [
      FieldValidation(student.text, studentError, true),
      FieldValidation(departing.text, departingError, !UserType.isTeacher()),
      FieldValidation(teacherDeparting.text, teacherDepartingError,
          departing.type == AppStrings.location),
      FieldValidation(teacherDestination.text, teacherDestinationError,
          destination.text!.isEmpty),
      FieldValidation(
          journeyTime.text, journeyTimeError, teacherDestination.value != -3),
      FieldValidation(ePassTime.text, ePassTimeError, true),
      FieldValidation(selectedDateApi.value, dateError, true),
      FieldValidation(selectedTimeApi.value, timeError, true),
    ];

    for (var field in fieldsToValidate) {
      field.validate();
    }

    if (fieldsToValidate.every((field) => !field.errorState.value)) {
      if (Utils.isPreviousTime(selectedTimeDate.value)) {
        selectedDate.value = Utils.formatDate(DateTime.now().toString(), false);
        selectedTime.value = Utils.formatTime(DateTime.now().toString(), false);
        selectedDateApi.value = Utils.formatDateApiLocal(DateTime.now());
        selectedTimeApi.value = Utils.formatTimeApiLocal(DateTime.now());
        selectedTimeDate.value = DateTime.now();
      }
      addNewPass();
    }
    update();
  }

  Future<void> getTimeData() async {
    await repository.getTimeData().then((value) async {
      journeyTimeList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
    }).onError((error, stackTrace) {});
  }

  Future<void> addNewPass() async {
    var request = {
      "studentId": student.value,
      "departingLocationId":
          departing.type == AppStrings.teacher ? 0 : departing.value,
      "departingTeacherId": teacherDeparting.value == -2
          ? departing.value
          : teacherDeparting.value,
      "destinationLocationId": destination.value == -1 ? 0 : destination.value,
      "destinationTeacherId":
          teacherDestination.value == -3 ? 0 : teacherDestination.value,
      "outTime": Utils.formatDateTimeApi(
          DateTime.parse('${selectedDateApi.value} ${selectedTimeApi.value}')),
      "journeyTimeId": journeyTime.value,
      "ePassTimeId": ePassTime.value,
      "comment": commentController.value.text
    };
    processing.value = true;
    await repository.addNewPass(request).then((value) async {
      processing.value = false;
      setData();
      var dashController = Get.put(DashboardModel());
      dashController.getToHome();
      Get.toNamed(Routes.trPasses);
      utils.successMessage(AppStrings.passIssued);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => addNewPass());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getStudentDropDown() async {
    await repository.getStudentsListDropDown().then((value) async {
      studentsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      getLocationDropDown();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getStudentDropDown());
      }
    });
  }

  Future<void> getLocationDropDown() async {
    await repository.getTeacherLocationsDropDown().then((value) async {
      allListMain =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      setDropDownData();
      update();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getLocationDropDown());
      } else {
        Utils.print(error.toString());
      }
    });
  }

  void setDropDownData() {
    teacherListDeparting.clear();
    teacherListDestination.clear();
    destinationList.clear();
    departingList.clear();

    for (int i = 0; i < allListMain.length; i++) {
      if (UserType.isTeacher()) {
        if (allListMain[i].type != AppStrings.teacher) {
          departingList.add(allListMain[i]);
        }
      } else {
        departingList.add(allListMain[i]);
      }
      if (allListMain[i].type == AppStrings.teacher) {
        if (UserType.isTeacher()) {
          if (ApiFilters.userId != allListMain[i].value) {
            teacherListDeparting.add(allListMain[i]);
            teacherListDestination.add(allListMain[i]);
          }
        } else {
          teacherListDeparting.add(allListMain[i]);
          teacherListDestination.add(allListMain[i]);
        }
      } else {
        destinationList.add(allListMain[i]);
      }
    }
  }

  void setFilterDropDownData() {
    teacherListDeparting.clear();
    teacherListDestination.clear();
    destinationList.clear();
    departingList.clear();

    for (int i = 0; i < allListMain.length; i++) {
      if (UserType.isTeacher()) {
        if (allListMain[i].type != AppStrings.teacher) {
          if (destination.value != allListMain[i].value) {
            departingList.add(allListMain[i]);
          }
        }
      } else {
        if (teacherDestination.value != allListMain[i].value &&
                teacherDestination.type != allListMain[i].type ||
            destination.value != allListMain[i].value &&
                destination.type != allListMain[i].type) {
          departingList.add(allListMain[i]);
        }
      }

      if (allListMain[i].type == AppStrings.teacher) {
        if (UserType.isTeacher()) {
          if (ApiFilters.userId != allListMain[i].value) {
            if (teacherDeparting.value != allListMain[i].value &&
                departing.value != allListMain[i].value) {
              teacherListDestination.add(allListMain[i]);
            }
            if (teacherDestination.value != allListMain[i].value) {
              teacherListDeparting.add(allListMain[i]);
            }
          }
        } else {
          if (teacherDeparting.value != allListMain[i].value &&
              departing.value != allListMain[i].value) {
            teacherListDestination.add(allListMain[i]);
          }
          if (teacherDestination.value != allListMain[i].value) {
            teacherListDeparting.add(allListMain[i]);
          }
        }
      } else {
        if (departing.value != allListMain[i].value) {
          destinationList.add(allListMain[i]);
        }
      }
    }
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
    final TimeOfDay? picked2 = await showTimePicker(
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

    if (picked2 != null) {
      DateTime dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          picked2.hour, picked2.minute);
      if (Utils.isMoreThanEPassTime(
          dateTime,
          SessionKeys.ePassTime == '' || UserType.isAdmin()
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
    setDropDownData();
    departingList = departingList;
    destinationList = destinationList;
    studentsList = studentsList;

    commentController.value.text = '';

    selectedDate = Utils.formatDate(DateTime.now().toString(), false).obs;
    selectedTime = Utils.formatTime(DateTime.now().toString(), false).obs;
    selectedDateApi = Utils.formatDateApiLocal(DateTime.now()).obs;
    selectedTimeApi = Utils.formatTimeApiLocal(DateTime.now()).obs;
    selectedTimeDate.value = DateTime.now();

    departing = ValueTextModel(value: 0, text: '', selected: false);
    if (!UserType.isTeacher()) {
      teacherDeparting = ValueTextModel(value: -2, text: '', selected: false);
    }
    teacherDestination = ValueTextModel(value: -3, text: '', selected: false);
    destination = ValueTextModel(value: -1, text: '', selected: false);
    student = ValueTextModel(value: 0, text: '', selected: false);
    journeyTime = ValueTextModel(value: 0, text: '', selected: false);
    ePassTime = ValueTextModel(value: 0, text: '', selected: false);
    dateColor = AppColors.grayDark;
    timeColor = AppColors.grayDark;

    update();
  }

  void dropdownSetting(int id) {
    if (id == 7) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
      studentSelect.value = false;
      journeySelect.value = false;
      ePassSelect.value = false;
    } else if (id == 6) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
      studentSelect.value = false;
      journeySelect.value = false;
    } else if (id == 5) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
      studentSelect.value = false;
      ePassSelect.value = false;
    } else if (id == 4) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
      journeySelect.value = false;
      ePassSelect.value = false;
    } else if (id == 3) {
      departingSelect.value = false;
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      studentSelect.value = false;
      journeySelect.value = false;
      ePassSelect.value = false;
    } else if (id == 2) {
      departingSelect.value = false;
      destinationSelect.value = false;
      destinationTeacherSelect.value = false;
      studentSelect.value = false;
      journeySelect.value = false;
      ePassSelect.value = false;
    } else if (id == 1) {
      departingSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
      studentSelect.value = false;
      journeySelect.value = false;
      ePassSelect.value = false;
    } else if (id == 0) {
      destinationSelect.value = false;
      departingTeacherSelect.value = false;
      destinationTeacherSelect.value = false;
      studentSelect.value = false;
      journeySelect.value = false;
      ePassSelect.value = false;
    }
  }

  bool showDepartTeacherDropDown() {
    return departing.type == AppStrings.location && !UserType.isTeacher();
  }

  bool checkLocationTeachers(context) {
    bool value = false;
    if (teacherDestination.value == teacherDeparting.value) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromTeacherAndDestinationCanNotBeSame);
    } else if (destination.value == departing.value) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromAndDestinationCanNotBeSame);
    } else if (departing.type == AppStrings.teacher &&
        departing.value == teacherDestination.value) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromTeacherAndDestinationCanNotBeSame);
    } else if (destination.type == AppStrings.teacher &&
        destination.value == teacherDeparting.value) {
      Utils.showMessage(context, AppStrings.incorrectData,
          AppStrings.departingFromTeacherAndDestinationCanNotBeSame);
    } else {
      value = true;
    }
    return value;
  }
}

class FieldValidation {
  final String? value;
  final RxBool errorState;
  final bool shouldValidate;

  FieldValidation(this.value, this.errorState, this.shouldValidate);

  void validate() {
    if (shouldValidate && (value == null || value!.isEmpty)) {
      errorState.value = true;
    }
  }
}
