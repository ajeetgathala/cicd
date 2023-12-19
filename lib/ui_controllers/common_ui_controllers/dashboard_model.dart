import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:get/get.dart';

class DashboardModel extends GetxController {
  RxString selected = AppStrings.home.obs;
  RxInt selectedIndex = 0.obs;

  void getToHome() {
    selectedIndex.value = 0;
    selected.value =
        UserType.isStudent() ? AppStrings.request : AppStrings.issuePass;
  }

  bool showAppBar() {
    bool key = true;
    if (UserType.isStudent()) {
      if (PrivilegeFirstFlags.canEPassRequest()) {
        if (selectedIndex.value == 2) {
          key = false;
        }
      } else {
        if (selectedIndex.value == 1) {
          key = false;
        }
      }
    } else {
      if (PrivilegeFirstFlags.canEPassIssue()) {
        if (selectedIndex.value == 2) {
          key = false;
        }
      } else {
        if (selectedIndex.value == 1) {
          key = false;
        }
      }
    }
    return key;
  }
}
