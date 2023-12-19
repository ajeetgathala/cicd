import 'dart:async';

import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/passes_status.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/models/all_models/passes_list_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrPassesModel extends GetxController {
  List<PassesListModel> data = <PassesListModel>[].obs;
  RxBool processing = true.obs;
  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  var selectedIds = [].obs;

  var filterData = <ValueTextModel>[].obs;

  RxBool selectMulti = false.obs;

  final searchControllerSt = TextEditingController().obs;
  final searchControllerL = TextEditingController().obs;

  void addFilterData() {
    filterData.clear();
    for (int i = 0; i < PassesStatus.data.length; i++) {
      if (![PassesStatus.completed, PassesStatus.rejected]
          .contains(PassesStatus.data[i].value)) {
        filterData.add(ValueTextModel(
            value: PassesStatus.data[i].value,
            type: '',
            text: PassesStatus.data[i].text,
            selected: true,
            search: true));
      } else {
        filterData.add(ValueTextModel(
            value: PassesStatus.data[i].value,
            type: '',
            text: PassesStatus.data[i].text,
            selected: false,
            search: true));
      }
    }
    setSelected();
  }

  final List<String> items = <String>[
    AppStrings.allPass,
    AppStrings.todayActive,
    AppStrings.todayInActive
  ].obs;

  RxString selectedValue = ''.obs;
  RxInt filterValue = 0.obs;

  Future<void> getData() async {
    await repository.getPasses().then((value) async {
      processing.value = true;
      processing.value = false;
      data = (value as List).map((i) => PassesListModel.fromJson(i)).toList();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getData());
      } else {
        processing.value = false;
      }
    });
  }

  void refreshOnNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      if (Get.currentRoute == Routes.trPasses) {
        getData();
      }
    });
  }

  bool isNotingSelected() {
    bool selectedAny = false;

    for (int i = 0; i < filterData.length; i++) {
      if (filterData[i].selected!) {
        selectedAny = true;
        break;
      }
    }

    return selectedAny;
  }

  bool isAllSelected() {
    bool selectedAny = true;

    for (int i = 0; i < filterData.length; i++) {
      if (!filterData[i].selected!) {
        selectedAny = false;
        break;
      }
    }

    return selectedAny;
  }

  bool isLocation(id) {
    return id != null && id != 0;
  }

  void setSelected() {
    selectedIds.clear();
    for (int i = 0; i < filterData.length; i++) {
      if (filterData[i].selected!) {
        selectedIds.add(filterData[i].value);
      }
    }
    processing.value = true;
    processing.value = false;
  }

  bool showPass(index) {
    return selectedIds.contains(data[index].status) || selectedIds.isEmpty;
  }

  double getBoxWidth(context, index) {
    return MediaQuery.of(context).size.width -
        (data[index].diffTime.toString() != '' &&
                data[index].diffTime.toString() != 'null'
            ? 270
            : 130);
  }

  String getFromText(index) {
    return isLocation(data[index].departingLocationId)
        ? '${data[index].departingLocationName.toString()}${data[index].departingTeacherId != null ? '(${data[index].departingTeacherName.toString()})' : ''}'
        : data[index].departingTeacherName.toString();
  }

  bool showOutTime(int index) {
    return data[index].outTime.toString() != 'null' &&
        data[index].outTime.toString() != '';
  }

  String getToText(index) {
    return isLocation(data[index].destinationLocationId)
        ? '${data[index].destinationLocationName.toString()}${data[index].destinationTeacherId != null ? '(${data[index].destinationTeacherName.toString()})' : ''}'
        : data[index].destinationTeacherName.toString();
  }

  bool showInTime(int index) {
    return data[index].inTime.toString() != 'null' &&
        data[index].inTime.toString() != '';
  }
}
