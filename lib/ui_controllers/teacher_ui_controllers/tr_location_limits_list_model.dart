import 'dart:async';

import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/location_limits_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class TrLocationLimitsListModel extends GetxController {
  List<LocationLimitsModel> data = <LocationLimitsModel>[].obs;

  RxBool processing = true.obs;
  var repository = getIt<Repositories>();

  Future<void> getData() async {
    // processing.value = true;
    await repository.getLocationLimits().then((value) async {
      processing.value = true;
      processing.value = false;
      data =
          (value as List).map((i) => LocationLimitsModel.fromJson(i)).toList();
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
      if (Get.currentRoute == Routes.trLocationLimitList) {
        getData();
      }
    });
  }
}
