import 'dart:async';

import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/passes_list_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class StPassesListModel extends GetxController {
  List<PassesListModel> data = <PassesListModel>[].obs;
  RxBool processing = false.obs;
  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> getData() async {
    processing.value = true;
    await repository.getStudentPasses().then((value) async {
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
      if (Get.currentRoute == Routes.stPassesList) {
        getData();
      }
    });
  }

  bool isLocation(id) {
    return id != null && id != 0;
  }

  bool showFromSubTitle(index) {
    return isLocation(data[index].departingLocationId) &&
        data[index].departingTeacherName != null;
  }

  bool showToSubTitle(int index) {
    return isLocation(data[index].destinationLocationId) &&
        data[index].destinationTeacherName != null;
  }

  bool showOutTime(int index) {
    return data[index].outTime.toString() != 'null' &&
        data[index].outTime.toString() != '';
  }

  bool showInTime(int index) {
    return data[index].inTime.toString() != 'null' &&
        data[index].inTime.toString() != '';
  }

  bool showDiffTime(int index) {
    return data[index].diffTime.toString() != 'null' &&
        data[index].diffTime.toString() != '';
  }

  String getFromIcon(index) {
    return isLocation(data[index].departingLocationId)
        ? AppIcon.officePng
        : Images.user;
  }

  String getFromImage(int index) {
    return isLocation(data[index].departingLocationId)
        ? data[index].departingLocationImage ?? ''
        : data[index].departingTeacherImage ?? '';
  }

  String getFromText(int index) {
    return isLocation(data[index].departingLocationId)
        ? data[index].departingLocationName.toString()
        : data[index].departingTeacherName.toString();
  }

  String getToIcon(int index) {
    return isLocation(data[index].destinationLocationId)
        ? AppIcon.officePng
        : Images.user;
  }

  String getToImage(int index) {
    return isLocation(data[index].destinationLocationId)
        ? data[index].destinationLocationImage ?? ''
        : data[index].destinationTeacherImage ?? '';
  }

  String getToText(int index) {
    return isLocation(data[index].destinationLocationId)
        ? data[index].destinationLocationName.toString()
        : data[index].destinationTeacherName.toString();
  }
}
