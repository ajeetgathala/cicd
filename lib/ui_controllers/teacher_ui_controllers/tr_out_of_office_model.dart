import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/all_models/tr_out_of_office_data_model.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrOutOfOfficeModel extends GetxController {
  List<ValueTextModel> teachersList = <ValueTextModel>[].obs;
  List<ValueTextModel> presetsList = <ValueTextModel>[].obs;
  List<ValueTextModel> repetitionList = <ValueTextModel>[].obs;

  final titleController = TextEditingController().obs;
  final reasonController = TextEditingController().obs;

  ValueTextModel preset = ValueTextModel(value: 0, text: '', selected: false);
  ValueTextModel repetition =
      ValueTextModel(value: 0, text: '', selected: false);
  ValueTextModel teacher = ValueTextModel(value: 0, text: '', selected: false);

  DateTime startTimeDateTime = DateTime.now();
  DateTime endTimeDateTime = DateTime.now().add(const Duration(hours: 1));

  RxString selectedDate =
      Utils.formatDate(DateTime.now().toString(), false).obs;
  RxString selectedDateApi = Utils.formatDateApi(DateTime.now()).obs;
  RxString selectedTime =
      Utils.formatTime(DateTime.now().toString(), false).obs;
  RxString startTimeApi = Utils.formatTimeApi(DateTime.now()).obs;
  RxString selectedTime1 = Utils.formatTime(
          DateTime.now().add(const Duration(hours: 1)).toString(), false)
      .obs;
  RxString endTimeApi =
      Utils.formatTimeApi(DateTime.now().add(const Duration(hours: 1))).obs;

  Color dateColor = AppColors.grayDark;
  Color sTimeColor = AppColors.grayDark;
  Color eTimeColor = AppColors.grayDark;

  late TrOutOfOfficeDataModel trOutOfOfficeDataModel;

  RxBool titleError = false.obs;
  RxBool teacherError = false.obs;
  RxBool presetsError = false.obs;
  RxBool dateError = false.obs;
  RxBool startTimeError = false.obs;
  RxBool endTimeError = false.obs;
  RxBool repetitionError = false.obs;
  RxBool reasonError = false.obs;

  RxBool processing = false.obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> validations() async {
    if (UserType.isTeacher()) {
      teacher = ValueTextModel(
          value: ApiFilters.userId, text: AppStrings.teacher, selected: false);
    }
    if (validated()) {
      if (Get.arguments[0] != 0) {
        editOutOfOffice();
      } else {
        addOutOfOffice();
      }
    }
    update();
  }

  Future<void> getTeachers() async {
    await repository.getTeacherDropDown().then((value) async {
      teachersList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      getPresets();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getTeachers());
      }
    });
  }

  Future<void> getPresets() async {
    await repository.getPresetsListDropDown().then((value) async {
      presetsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      getRepetitions();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getPresets());
      }
    });
  }

  Future<void> getRepetitions() async {
    await repository.getRepetitionListDropDown().then((value) async {
      repetitionList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      if (Get.arguments[0] != 0) {
        getDataById();
      }
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getRepetitions());
      }
    });
    update();
  }

  Future<void> editOutOfOffice() async {
    processing.value = true;

    var request = {
      "id": Get.arguments[0],
      "title": titleController.value.text,
      "teacherId": teacher.value,
      "presets": preset.value.toString(),
      "startTime": startTimeApi.value,
      "endTime": endTimeApi.value,
      "startDate": selectedDateApi.value,
      "repetition": repetition.value.toString(),
      "reason": reasonController.value.text
    };

    await repository.editOutOfOffice(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.outOfOfficeEdited);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => editOutOfOffice());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> addOutOfOffice() async {
    processing.value = true;

    var request = {
      "title": titleController.value.text,
      "teacherId": teacher.value,
      "presets": preset.value.toString(),
      "startTime": startTimeApi.value,
      "endTime": endTimeApi.value,
      "startDate": selectedDateApi.value,
      "repetition": repetition.value.toString(),
      "reason": reasonController.value.text
    };

    await repository.addOutOfOffice(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.addedOutOfOffice);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => addOutOfOffice());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getDataById() async {
    // processing.value = true;
    await repository.getOutOfOfficeById(Get.arguments[0]).then((value) async {
      processing.value = true;
      processing.value = false;
      trOutOfOfficeDataModel = TrOutOfOfficeDataModel.fromJson(value);
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
    titleController.value.text = AppStrings.title;
    reasonController.value.text = trOutOfOfficeDataModel.reason.toString();

    selectedDate.value = trOutOfOfficeDataModel.startDate.toString().trim();
    selectedDateApi.value = trOutOfOfficeDataModel.startDate.toString().trim();
    selectedTime.value = Utils.formatTimeToTime(
        trOutOfOfficeDataModel.startTime.toString().trim());
    startTimeApi.value = trOutOfOfficeDataModel.startTime.toString().trim();
    selectedTime1.value = Utils.formatTimeToTime(
        trOutOfOfficeDataModel.endTime.toString().trim());
    endTimeApi.value = trOutOfOfficeDataModel.endTime.toString().trim();
    setupDropDowns();
    update();
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
      selectedDateApi.value = Utils.formatDateApi(picked);
      dateColor = AppColors.grayDark;
    }
  }

  Future<void> selectTime(BuildContext context, int first) async {
    final currentContext = context;
    final TimeOfDay? picked2 = await showTimePicker(
      context: currentContext,
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
      initialTime: first == 0
          ? TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute)
          : TimeOfDay(
              hour: DateTime.now().hour + 1, minute: DateTime.now().minute),
    );

    if (picked2 != null) {
      DateTime dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          picked2.hour, picked2.minute);
      if (first == 0) {
        selectedTime.value = Utils.formatTime(dateTime.toString(), false);
        startTimeApi.value = Utils.formatTimeApi(dateTime);
        sTimeColor = AppColors.grayDark;
        startTimeDateTime = DateTime(dateTime.year, dateTime.month,
            dateTime.day, picked2.hour, picked2.minute);
      } else {
        endTimeDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            picked2.hour, picked2.minute);
        if (endTimeDateTime.isBefore(startTimeDateTime)) {
          utils.snackBarMessage(
              AppStrings.invalidTime, AppStrings.endTimeCantBe);
          Future.delayed(Duration.zero, () {
            selectTime(currentContext, first);
          });
        } else {
          selectedTime1.value = Utils.formatTime(dateTime.toString(), false);
          endTimeApi.value = Utils.formatTimeApi(dateTime);
          eTimeColor = AppColors.grayDark;
        }
      }
    }
  }

  bool validated() {
    bool v = false;
    titleError.value = false;
    presetsError.value = false;
    dateError.value = false;
    startTimeError.value = false;
    endTimeError.value = false;
    repetitionError.value = false;
    reasonError.value = false;
    if (titleController.value.text.isEmpty) {
      titleError.value = true;
    } else if (preset.text!.isEmpty) {
      presetsError.value = true;
    } else if (selectedDateApi.isEmpty) {
      dateError.value = true;
    } else if (startTimeApi.isEmpty) {
      startTimeError.value = true;
    } else if (endTimeApi.isEmpty) {
      endTimeError.value = true;
    } else if (teacher.text!.isEmpty && !UserType.isTeacher()) {
      teacherError.value = true;
    } else if (repetition.text!.isEmpty) {
      repetitionError.value = true;
    } else {
      v = true;
    }
    return v;
  }

  void setupDropDowns() {
    for (int i = 0; i < teachersList.length; i++) {
      if (trOutOfOfficeDataModel.teacherId == teachersList[i].value) {
        teacher = teachersList[i];
      }
    }
    for (int i = 0; i < presetsList.length; i++) {
      if (trOutOfOfficeDataModel.presets == presetsList[i].text ||
          trOutOfOfficeDataModel.presets == presetsList[i].value.toString()) {
        preset = presetsList[i];
      }
    }
    for (int i = 0; i < repetitionList.length; i++) {
      if (trOutOfOfficeDataModel.repetition == repetitionList[i].text ||
          trOutOfOfficeDataModel.repetition ==
              repetitionList[i].value.toString()) {
        repetition = repetitionList[i];
      }
    }
  }
}
