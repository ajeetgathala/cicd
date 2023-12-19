import 'dart:async';

import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/tr_out_of_office_data_model_list.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class TrOutOfOfficeListModel extends GetxController {
  List<TrOutOfOfficeDataModelList> data = <TrOutOfOfficeDataModelList>[].obs;
  RxBool processing = true.obs;
  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> getData() async {
    await repository.getOutOfOfficeList().then((value) async {
      processing.value = true;
      processing.value = false;
      data = (value as List)
          .map((i) => TrOutOfOfficeDataModelList.fromJson(i))
          .toList();
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
      if (Get.currentRoute == Routes.trOutOfOfficeList) {
        getData();
      }
    });
  }

  String showTime(index) {
    return '${data[index].startDate.toString()} '
        '(${Utils.formatTimeToTime(data[index].startTime.toString())} '
        '- ${Utils.formatTimeToTime(data[index].endTime.toString())})';
  }
}
