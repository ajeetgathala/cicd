import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';

import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/all_models/tr_location_limit_by_id.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrLimitStudentFormModel extends GetxController {
  final reasonController = TextEditingController().obs;
  final searchController = TextEditingController().obs;

  RxString startDate = Utils.formatDate(DateTime.now().toString(), false).obs;
  RxString endDate = Utils.formatDate(
          DateTime.now().add(const Duration(days: 1)).toString(), false)
      .obs;

  RxString startDateApi = Utils.formatDateApi(DateTime.now()).obs;
  RxString endDateApi =
      Utils.formatDateApi(DateTime.now().add(const Duration(days: 1))).obs;

  late TrLocationLimitById trLocationLimitById;

  Color sDateColor = AppColors.grayDark;
  Color eDateColor = AppColors.grayDark;

  List<ValueTextModel> studentsList = <ValueTextModel>[].obs;
  List<ValueTextModel> repetitionList = <ValueTextModel>[].obs;
  List<ValueTextModel> limitsList = <ValueTextModel>[].obs;

  ValueTextModel selectedRepetition =
      ValueTextModel(value: -1, text: '', type: '', selected: false);

  ValueTextModel repetition =
      ValueTextModel(value: 0, text: '', type: '', selected: false);
  ValueTextModel limit =
      ValueTextModel(value: -1, text: '', type: '', selected: false);

  RxBool selectAll = false.obs;

  RxBool selectMulti = false.obs;

  var calStartDate = DateTime.now().obs;
  var endDateTime = DateTime.now().add(const Duration(days: 1)).obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  RxBool studentError = false.obs;
  RxBool limitError = false.obs;
  RxBool startDateError = false.obs;
  RxBool entDateError = false.obs;
  RxBool processing = false.obs;
  RxBool reasonError = false.obs;
  RxBool repetitionError = false.obs;

  Future<void> validations() async {
    if (validated()) {
      if (Get.arguments[0] == 0) {
        addStudentPassLimit();
      } else {
        editStudentPassLimit();
      }
    }
    update();
  }

  Future<void> getDataById() async {
    processing.value = true;
    await repository
        .getLimitStudentPasseById(Get.arguments[0])
        .then((value) async {
      processing.value = false;
      trLocationLimitById = TrLocationLimitById.fromJson(value);
      setData();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getDataById());
      } else {
        processing.value = false;
      }
    });
  }

  void setData() {
    limit.text = trLocationLimitById.passLimit!.toString();
    limit.value = trLocationLimitById.passLimitId!;
    startDate.value = Utils.formatDate(trLocationLimitById.startDate!, false);
    startDateApi.value =
        Utils.formatDateApi(DateTime.parse(trLocationLimitById.startDate!));
    endDate.value = Utils.formatDate(trLocationLimitById.endDate!, false);
    endDateApi.value =
        Utils.formatDateApi(DateTime.parse(trLocationLimitById.endDate!));
    endDateTime.value = DateTime.now()..add(const Duration(days: 1));
    reasonController.value.text = trLocationLimitById.reason!;
    repetition = ValueTextModel(value: 0, text: '', selected: false);
    eDateColor = AppColors.grayDark;
    sDateColor = AppColors.grayDark;

    for (int i = 0; i < studentsList.length; i++) {
      if (trLocationLimitById.studentIdArr!
          .contains(studentsList[i].value.toString())) {
        studentsList[i].selected = true;
      }
    }
    for (int i = 0; i < repetitionList.length; i++) {
      if (trLocationLimitById.repetitionId == repetitionList[i].value) {
        selectedRepetition = repetitionList[i];
        repetition = repetitionList[i];
        break;
      }
    }
  }

  Future<void> editStudentPassLimit() async {
    processing.value = true;
    List<int> selectedStudents = [];
    for (int i = 0; i < studentsList.length; i++) {
      if (studentsList[i].selected!) {
        selectedStudents.add(studentsList[i].value!);
      }
    }

    var request = {
      "id": trLocationLimitById.id,
      "passLimit": limit.value,
      "startDate": startDateApi.value,
      "endDate": endDateApi.value,
      "repetitionId": repetition.value,
      "reason": reasonController.value.text,
      "studentIdArr": selectedStudents.join(','),
      "districtId": ApiFilters.districtId
    };

    await repository.editLimitStudentPasses(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.studentPassLimitUpdated);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => editStudentPassLimit());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> addStudentPassLimit() async {
    processing.value = true;
    List<int> selectedStudents = [];
    for (int i = 0; i < studentsList.length; i++) {
      if (studentsList[i].selected!) {
        selectedStudents.add(studentsList[i].value!);
      }
    }

    var request = {
      "passLimit": limit.value,
      "startDate": startDateApi.value,
      "endDate": endDateApi.value,
      "repetitionId": repetition.value,
      "reason": reasonController.value.text,
      "studentIdArr": selectedStudents.join(','),
      "districtId": ApiFilters.districtId
    };

    await repository.addLimitStudentPasses(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.studentPassLimitAdded);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => addStudentPassLimit());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getStudentDropDownsData() async {
    await repository.getStudentsListDropDown().then((value) async {
      studentsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      getLimits();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getStudentDropDownsData());
      }
    });
  }

  Future<void> getRepetitionsDropDownsData() async {
    await repository.getRepetitionListDropDown().then((value) async {
      repetitionList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      update();
      if (Get.arguments[0] != 0) {
        getDataById();
      }
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository
            .tokenRefreshApi()
            .then((value) => getRepetitionsDropDownsData());
      }
    });
  }

  Future<void> getLimits() async {
    await repository.getLimits().then((value) async {
      limitsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      getRepetitionsDropDownsData();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getLimits());
      }
    });
  }

  Future<void> selectDate(BuildContext context, int first) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: calStartDate.value,
        firstDate: first == 0 ? DateTime.now() : calStartDate.value,
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
      if (first == 0) {
        sDateColor = AppColors.grayDark;
        startDate.value = Utils.formatDate(picked.toString(), false);
        startDateApi.value = Utils.formatDateApiNoUtc(picked);
        calStartDate.value = picked;
        if (picked.isAfter(endDateTime.value)) {
          endDateApi.value =
              Utils.formatDateApi(picked.add(const Duration(days: 1)));
          endDate.value = Utils.formatDate(
              picked.add(const Duration(days: 1)).toString(), false);
          endDateTime.value = picked.add(const Duration(days: 1));
          update();
        }
      } else {
        eDateColor = AppColors.grayDark;
        endDate.value = Utils.formatDate(picked.toString(), false);
        endDateApi.value = Utils.formatDateApiNoUtc(picked);
        endDateTime.value = picked;
      }
    }
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

  void filterStudents() {
    if (searchController.value.text.trim().isEmpty) {
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
            .contains(searchController.value.text.toLowerCase())) {
          studentsList[i].search = true;
        } else {
          studentsList[i].search = false;
        }
      }
    }
    update();
  }

  bool validated() {
    bool v = false;
    studentError.value = false;
    limitError.value = false;
    startDateError.value = false;
    entDateError.value = false;
    reasonError.value = false;

    repetitionError.value = false;
    if (!isNotingSelected()) {
      studentError.value = true;
    } else if (limit.text!.isEmpty) {
      limitError.value = true;
    } else if (startDateApi.value.isEmpty) {
      startDateError.value = true;
    } else if (endDateApi.value.isEmpty) {
      entDateError.value = true;
    } else if (repetition.text!.isEmpty) {
      repetitionError.value = true;
    } else {
      v = true;
    }
    return v;
  }
}
