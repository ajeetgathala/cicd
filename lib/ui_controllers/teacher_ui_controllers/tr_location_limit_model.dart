import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';

import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';

import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/models/all_models/tr_location_limit_data_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrLocationLimitModel extends GetxController {
  List<ValueTextModel> locationsList = <ValueTextModel>[].obs;
  List<ValueTextModel> limitsList = <ValueTextModel>[].obs;
  final searchController = TextEditingController().obs;

  // final limitController = TextEditingController().obs;
  RxString selectedDate =
      Utils.formatDate(DateTime.now().toString(), false).obs;
  RxString selectedDatePost = Utils.formatDateApi(DateTime.now()).obs;
  late TrLocationLimitDataModel limitsModel;
  ValueTextModel limit =
      ValueTextModel(value: -1, text: '', type: '', selected: false);
  Color dateColor = AppColors.grayDark;
  RxBool selectAll = false.obs;
  RxBool selectMulti = false.obs;
  RxBool locationStatusError = false.obs;
  RxBool limitError = false.obs;
  RxBool dateError = false.obs;
  RxBool processing = false.obs;

  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();
  RxBool edit = false.obs;

  Future<void> validations() async{
    if (validated()) {
      if (edit.value) {
        editLimit();
      } else {
        addLocationLimit();
      }
    }
  }

  Future<void> addLocationLimit() async {
    processing.value = true;
    List<int> selectedItems = [];
    for (int i = 0; i < locationsList.length; i++) {
      if (locationsList[i].selected!) {
        selectedItems.add(locationsList[i].value!);
      }
    }
    var request = {
      "limit": limit.value,
      "expireDate": selectedDatePost.value,
      "locationIdArr": selectedItems.join(','),
      "districtId": ApiFilters.getDistrictId()
    };

    await repository.addLocationLimit(request).then((value) async {
      processing.value = false;

      Get.back();

      utils.successMessage(AppStrings.locationLimitAdded);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => addLocationLimit());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getLocationLimits() async {
    await repository.getLocations().then((value) async {
      locationsList = [];
      locationsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      update();
      getLimits();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getLocationLimits());
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
      selectedDatePost.value = utils.appDateTime(picked);
      dateColor = AppColors.grayDark;
    }
  }

  bool isNotingSelected() {
    bool selectedAny = false;
    for (int i = 0; i < locationsList.length; i++) {
      if (locationsList[i].selected!) {
        selectedAny = true;
      }
    }
    return selectedAny;
  }

  bool isAllSelected() {
    bool selectedAny = true;
    if (locationsList.isNotEmpty) {
      for (int i = 0; i < locationsList.length; i++) {
        if (!locationsList[i].selected!) {
          selectedAny = false;
          break;
        }
      }
    } else {
      selectedAny = false;
    }

    return selectedAny;
  }

  void setData() {
    limit.text = limitsModel.limit.toString();
    limit.value = limitsModel.limitId;
    selectedDate.value = Utils.formatDate(limitsModel.expireDate!, false);
    dateColor = AppColors.grayDark;
    selectedDatePost.value = limitsModel.expireDate!;
    edit.value = true;
    for (int i = 0; i < locationsList.length; i++) {
      if (limitsModel.locationIdArr!
          .contains(locationsList[i].value.toString())) {
        locationsList[i].selected = true;
      }
    }
  }

  Future<void> editLimit() async {
    processing.value = true;
    List<int> selectedItems = [];
    for (int i = 0; i < locationsList.length; i++) {
      if (locationsList[i].selected!) {
        selectedItems.add(locationsList[i].value!);
      }
    }
    var request = {
      "id": Get.arguments[0],
      "limit": limit.value,
      "expireDate": selectedDatePost.value,
      "locationIdArr": selectedItems.join(','),
      "districtId": ApiFilters.districtId
    };

    await repository.editLocationLimit(request).then((value) async {
      processing.value = false;

      Get.back();
      utils.successMessage(AppStrings.locationLimitEdited);
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => editLimit());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getDataById() async {
    processing.value = true;
    await repository.getLocationLimitById(Get.arguments[0]).then((value) async {
      processing.value = false;
      limitsModel = TrLocationLimitDataModel.fromJson(value);
      setData();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getDataById());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getLimits() async {
    await repository.getLimits().then((value) async {
      limitsList =
          (value as List).map((i) => ValueTextModel.fromJson(i)).toList();
      update();
      if (Get.arguments[0] != 0) {
        getDataById();
      }
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getLimits());
      }
    });
  }

  void filterLocations() {
    if (searchController.value.text.trim().isEmpty) {
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
            .contains(searchController.value.text.toLowerCase())) {
          locationsList[i].search = true;
        } else {
          locationsList[i].search = false;
        }
      }
    }
    update();
  }

  bool validated() {
    bool v = false;
    locationStatusError.value = false;
    limitError.value = false;
    dateError.value = false;
    if (!isNotingSelected()) {
      locationStatusError.value = true;
    } else if (limit.text!.isEmpty) {
      limitError.value = true;
    } else if (selectedDatePost.isEmpty) {
      dateError.value = true;
    } else {
      v = true;
    }
    return v;
  }
}
