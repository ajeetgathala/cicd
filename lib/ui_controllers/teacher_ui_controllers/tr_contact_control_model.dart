import 'dart:async';

import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/tr_contact_control_list_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class TrContactControlModel extends GetxController {
  List<ContactControlListModel> data = <ContactControlListModel>[].obs;
  RxBool processing = true.obs;
  var repository = getIt<Repositories>();

  Future<void> getData() async {
    await repository.getContactControlList().then((value) async {
      processing.value = true;
      processing.value = false;
      data = (value as List)
          .map((i) => ContactControlListModel.fromJson(i))
          .toList();
      update();
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
      if (Get.currentRoute == Routes.trContactControl) {
        getData();
      }
    });
  }
}
