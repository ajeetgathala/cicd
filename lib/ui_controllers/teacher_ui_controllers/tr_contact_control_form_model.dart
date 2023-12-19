import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';

import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/all_models/contact_control_id_model.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrContactControlFromModel extends GetxController {
  final adminController = TextEditingController().obs;
  final searchControllerSt = TextEditingController().obs;
  final searchControllerL = TextEditingController().obs;

  RxString selectedDate =
      Utils.formatDate(DateTime.now().toString(), false).obs;
  RxString selectedTime =
      Utils.formatTime(DateTime.now().toString(), false).obs;
  RxString selectedDateApi = Utils.formatDateApi(DateTime.now()).obs;
  RxString selectedTimeApi = Utils.formatTimeApi(DateTime.now()).obs;

  List<ValueTextModel> studentsList = <ValueTextModel>[].obs;
  List<ValueTextModel> locationsList = <ValueTextModel>[].obs;
  late ContactControlIdModel contactControlIdModel;
  Color dateColor = AppColors.grayDark;
  Color timeColor = AppColors.grayDark;

  RxBool selectAll = false.obs;
  RxBool processing = false.obs;

  RxBool studentError = false.obs;
  RxBool locationError = false.obs;
  RxBool expiryError = false.obs;
  RxBool timeError = false.obs;
  RxBool adminError = false.obs;

  RxBool selectMulti = false.obs;

  RxBool selectAll1 = false.obs;

  RxBool selectMulti1 = false.obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> validations() async {
    studentError.value = false;
    locationError.value = false;
    expiryError.value = false;
    timeError.value = false;
    adminError.value = false;
    if (!isNotingSelected()) {
      studentError.value = true;
    } else if (!isLocationNotingSelected()) {
      locationError.value = true;
    } else if (selectedDateApi.isEmpty) {
      expiryError.value = true;
    } else if (selectedTimeApi.isEmpty) {
      timeError.value = true;
      // } else if (adminController.value.text.isEmpty) {
      //   adminError.value = true;
    } else {
      if (Get.arguments[0] == 0) {
        addContactControl();
      } else {
        editContactControl();
      }
    }
    update();
  }

  Future<void> addContactControl() async {
    processing.value = true;
    List<int> selectedStudents = [];
    for (int i = 0; i < studentsList.length; i++) {
      if (studentsList[i].selected!) {
        selectedStudents.add(studentsList[i].value!);
      }
    }
    List<int> selectedLocations = [];
    for (int i = 0; i < locationsList.length; i++) {
      if (locationsList[i].selected!) {
        selectedLocations.add(locationsList[i].value!);
      }
    }
    var request = {
      "adminOnlyNote": adminController.value.text.trim(),
      "expireDate": selectedDateApi.value,
      "expireTime": selectedTimeApi.value,
      "studentIdArr": selectedStudents.join(','),
      "locationIdArr": selectedLocations.join(','),
      "districtId": ApiFilters.districtId
    };

    await repository.addContactControl(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.contactControlAdded);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => addContactControl());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> editContactControl() async {
    processing.value = true;
    List<int> selectedStudents = [];
    for (int i = 0; i < studentsList.length; i++) {
      if (studentsList[i].selected!) {
        selectedStudents.add(studentsList[i].value!);
      }
    }
    List<int> selectedLocations = [];
    for (int i = 0; i < locationsList.length; i++) {
      if (locationsList[i].selected!) {
        selectedLocations.add(locationsList[i].value!);
      }
    }

    {}
    var request = {
      "id": contactControlIdModel.id!,
      "adminOnlyNote": adminController.value.text.trim(),
      "expireDate": selectedDateApi.value,
      "expireTime": selectedTimeApi.value,
      "studentIdArr": selectedStudents.join(','),
      "locationIdArr": selectedLocations.join(','),
      "districtId": ApiFilters.districtId
    };

    await repository.editContactControl(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.editedContactControl);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => editContactControl());
      } else {
        processing.value = false;
      }
    });
  }

  void setData() {
    selectedDate.value = contactControlIdModel.expireDate!;
    selectedDateApi.value = contactControlIdModel.expireDate!;
    selectedTime.value =
        Utils.formatTimeToTime(contactControlIdModel.expireTime!);
    selectedTimeApi.value = contactControlIdModel.expireTime!;
    adminController.value.text = contactControlIdModel.adminOnlyNote!;
    dateColor = AppColors.grayDark;
    timeColor = AppColors.grayDark;

    for (int i = 0; i < studentsList.length; i++) {
      if (contactControlIdModel.studentId!
          .contains(studentsList[i].value.toString())) {
        studentsList[i].selected = true;
      }
    }
    for (int i = 0; i < locationsList.length; i++) {
      if (contactControlIdModel.locationId!
          .contains(locationsList[i].value.toString())) {
        locationsList[i].selected = true;
      }
    }
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
    await repository.getLocations().then((value) async {
      locationsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      if (Get.arguments[0] != 0) {
        getDataById();
      }
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getLocationDropDown());
      }
    });
  }

  Future<void> getDataById() async {
    processing.value = true;
    await repository
        .getContactControlById(Get.arguments[0])
        .then((value) async {
      processing.value = false;
      contactControlIdModel = ContactControlIdModel.fromJson(value);
      setData();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getDataById());
      } else {
        processing.value = false;
      }
    });
  }

  bool isNotingSelected() {
    bool selectedAny = false;
    for (int i = 0; i < studentsList.length; i++) {
      if (studentsList[i].selected!) {
        selectedAny = true;
      }
    }
    return selectedAny;
  }

  bool isAllSelected() {
    bool selectedAny = true;

    for (int i = 0; i < studentsList.length; i++) {
      if (!studentsList[i].selected!) {
        selectedAny = false;
      }
    }

    return selectedAny;
  }

  bool isLocationNotingSelected() {
    bool selectedAny = false;
    for (int i = 0; i < locationsList.length; i++) {
      if (locationsList[i].selected!) {
        selectedAny = true;
      }
    }
    return selectedAny;
  }

  bool isLocationAllSelected() {
    bool selectedAny = true;
    for (int i = 0; i < locationsList.length; i++) {
      if (!locationsList[i].selected!) {
        selectedAny = false;
      }
    }
    return selectedAny;
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
      dateColor = AppColors.grayDark;
      selectedDate.value = Utils.formatDate(picked.toString(), false);
      selectedDateApi.value = Utils.formatDateApiLocal(picked);
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
      timeColor = AppColors.grayDark;
      selectedTime.value = Utils.formatTime(dateTime.toString(), false);
      selectedTimeApi.value = Utils.formatTimeApi(dateTime);
    }
  }

  void filterStudents() {
    if (searchControllerSt.value.text.trim().isEmpty) {
      for (int i = 0; i < studentsList.length; i++) {
        if (!studentsList[i].search!) {
          studentsList[i].search = true;
        }
      }
    } else {
      for (int i = 0; i < studentsList.length; i++) {
        if (studentsList[i]
            .text!
            .toLowerCase()
            .contains(searchControllerSt.value.text.toLowerCase())) {
          studentsList[i].search = true;
        } else {
          studentsList[i].search = false;
        }
      }
    }
    update();
  }

  void filterLocations() {
    if (searchControllerL.value.text.trim().isEmpty) {
      for (int i = 0; i < locationsList.length; i++) {
        if (!locationsList[i].search!) {
          locationsList[i].search = true;
        }
      }
    } else {
      for (int i = 0; i < locationsList.length; i++) {
        if (locationsList[i]
            .text!
            .toLowerCase()
            .contains(searchControllerL.value.text.toLowerCase())) {
          locationsList[i].search = true;
        } else {
          locationsList[i].search = false;
        }
      }
    }
    update();
  }
}
