import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/all_models/tr_notification_settings_data_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:get/get.dart';

class NotificationSettingsModel extends GetxController {
  RxBool allSwitch = true.obs;
  RxBool newSwitch = true.obs;
  RxBool reminderSwitch = false.obs;
  RxBool alertSwitch = false.obs;
  RxBool completeSwitch = false.obs;
  RxBool departedSwitch = false.obs;

  List<TrNotificationSettingsDataModel> data =
      <TrNotificationSettingsDataModel>[].obs;
  RxBool processing = true.obs;
  var repository = getIt<Repositories>();
  var utils = getIt<Utils>();

  Future<void> getData() async {
    await repository
        .getNotificationSettings(
            await AppSharedPreferences.getInt(AppSharedPreferences.id))
        .then((value) async {
      processing.value = false;
      data = (value as List)
          .map((i) => TrNotificationSettingsDataModel.fromJson(i))
          .toList();
      allSwitch.value = data[0].allNotifications!;
      newSwitch.value = data[0].newPassNotifications!;
      reminderSwitch.value = data[0].reminders!;
      alertSwitch.value = data[0].alerts!;
      completeSwitch.value = data[0].completed!;
      departedSwitch.value = data[0].departed!;
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => getData());
      } else {
        processing.value = false;
      }
    });
  }

  Future<void> postSettings() async {
    var request = {
      "userId": await AppSharedPreferences.getInt(AppSharedPreferences.id),
      "allNotifications": allSwitch.value ? 1 : 0,
      "newPassNotifications": newSwitch.value ? 1 : 0,
      "reminders": reminderSwitch.value ? 1 : 0,
      "alerts": alertSwitch.value ? 1 : 0,
      "completed": completeSwitch.value ? 1 : 0,
      "departed": departedSwitch.value ? 1 : 0
    };
    await repository.postNotificationSetting(request).then((value) async {
      getData();
    }).onError((error, stackTrace) async {
      if (Utils.needToken(error!)) {
        await repository.tokenRefreshApi().then((value) => postSettings());
      }
    });
  }

  void allSwitchCheck() {
    if (allSwitch.value) {
      newSwitch.value = true;
      reminderSwitch.value = true;
      alertSwitch.value = true;
      completeSwitch.value = true;
      departedSwitch.value = true;
    } else {
      newSwitch.value = false;
      reminderSwitch.value = false;
      alertSwitch.value = false;
      completeSwitch.value = false;
      departedSwitch.value = false;
    }
  }

  void dataCheck() {
    if (newSwitch.value &&
        reminderSwitch.value &&
        alertSwitch.value &&
        completeSwitch.value &&
        departedSwitch.value) {
      allSwitch.value = true;
    } else {
      allSwitch.value = false;
    }
  }
}
