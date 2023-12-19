import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/tr_notifications_data_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationsAlertsModel extends GetxController {
  List<TrNotificationsDataModel> data = <TrNotificationsDataModel>[].obs;
  RxBool processing = false.obs;
  var repository = getIt<Repositories>();
  bool fromDashboard = Get.arguments[0] == 0;

  Future<void> getData() async {
    processing.value = true;
    await repository
        .getNotifications(
            await AppSharedPreferences.getInt(AppSharedPreferences.id))
        .then((value) async {
      processing.value = false;
      data = (value as List)
          .map((i) => TrNotificationsDataModel.fromJson(i))
          .toList();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getData());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> getAlerts() async {
    processing.value = true;
    await repository.getAlerts(Get.arguments[0]).then((value) async {
      processing.value = false;
      data = (value as List)
          .map((i) => TrNotificationsDataModel.fromJson(i))
          .toList();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getAlerts());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> fetchData() async {
    if (fromDashboard) {
      getData();
    } else {
      getAlerts();
    }
  }

  void refreshOnNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      if (Get.currentRoute == Routes.trNotifications) {
        if (fromDashboard) {
          getData();
        } else {
          getAlerts();
        }
      }
    });
  }
}
