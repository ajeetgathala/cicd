import 'package:cicd/app_flags/first_privilege.dart';
import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/screens/common/profile.dart';
import 'package:cicd/screens/student/st_new_request.dart';
import 'package:cicd/screens/student/st_passes_list.dart';
import 'package:cicd/screens/teacher/tr_home.dart';
import 'package:cicd/screens/teacher/tr_issue_pass.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/profile_screen_model.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/dashboard_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_home_model.dart';
import 'package:cicd/utils/utils.dart';
import 'package:cicd/widgets/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var controller = Get.put(DashboardModel());
  var controller2 = Get.put(TrHomeModel());
  var profileController = Get.put(ProfileScreenModel());

  void _onItemTapped(int index) {
    if (controller2.isSchoolSelected.value ||
        UserType.isStudent() ||
        UserType.isTeacher() ||
        UserType.isSchoolOperator() ||
        index != 1) {
      if (index == 0) {
        controller.selected.value = AppStrings.home;
      } else if (index == 1) {
        controller.selected.value = AppStrings.newEPass;
      } else {
        controller.selected.value = AppStrings.profile;
      }
      controller.selectedIndex.value = index;
    } else {
      Utils.showMessage(
          context,
          '',
          UserType.isAdmin()
              ? AppStrings.pleaseSelectDistrictAndSchool
              : AppStrings.pleaseSelectSchool);
    }
  }

  @override
  void initState() {
    controller.selectedIndex.value = Get.arguments[0];
    controller2
        .getStatusData()
        .then((value) => profileController.getProfileData());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    Get.offAllNamed(Routes.dashboard, arguments: [0]);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => profileController.processing.value
        ? const Scaffold()
        : RefreshIndicator(
            onRefresh: () => getData(),
            child: Scaffold(
                backgroundColor: AppColors.whiteColor,
                resizeToAvoidBottomInset: false,
                body: Obx(() => IndexedStack(
                      sizing: StackFit.loose,
                      index: controller.selectedIndex.value,
                      children: UserType.isStudent()
                          ? [
                              const StPassesList(),
                              if (PrivilegeFirstFlags.canEPassRequest())
                                const StNewRequest(),
                              const Profile()
                            ]
                          : [
                              const TrHome(),
                              if (PrivilegeFirstFlags.canEPassIssue())
                                const TrNewPass(),
                              const Profile()
                            ],
                    )),
                appBar: controller.showAppBar()
                    ? AppBar(
                        backgroundColor: AppColors.whiteColor,
                        elevation: 0,
                        title: Obx(() => TitleText(
                              title: controller.selected.value,
                            )),
                        centerTitle: true,
                        leading: Container(),
                        actions: [
                          if (!UserType.isStudent())
                            InkWell(
                              onTap: () {
                                if (controller2.isSchoolSelected.value ||
                                    UserType.isTeacher() ||
                                    UserType.isSchoolOperator()) {
                                  Get.toNamed(Routes.trNotifications,
                                      arguments: [0]);
                                } else {
                                  Utils.showMessage(
                                      context,
                                      '',
                                      UserType.isAdmin()
                                          ? AppStrings
                                              .pleaseSelectDistrictAndSchool
                                          : AppStrings.pleaseSelectSchool);
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(15),
                                  child: const Icon(Icons.notifications_none)),
                            )
                        ],
                      )
                    : null,
                bottomNavigationBar: Obx(
                  () => UserType.isStudent()
                      ? BottomNavigationBar(
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: const ImageIcon(
                                AssetImage(AppIcon.tabHome),
                              ),
                              label: AppStrings.home,
                            ),
                            if (PrivilegeFirstFlags.canEPassRequest())
                              BottomNavigationBarItem(
                                icon: const ImageIcon(
                                  AssetImage(AppIcon.tabRequest),
                                ),
                                label: AppStrings.request,
                              ),
                            BottomNavigationBarItem(
                              icon: const ImageIcon(
                                AssetImage(AppIcon.tabProfile),
                              ),
                              label: AppStrings.profile,
                            ),
                          ],
                          currentIndex: controller.selectedIndex.value,
                          selectedItemColor: AppColors.blue,
                          onTap: _onItemTapped,
                        )
                      : BottomNavigationBar(
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: const ImageIcon(
                                AssetImage(AppIcon.tabHome),
                              ),
                              label: AppStrings.home,
                            ),
                            if (PrivilegeFirstFlags.canEPassIssue())
                              BottomNavigationBarItem(
                                icon: const ImageIcon(
                                  AssetImage(AppIcon.tabRequest),
                                ),
                                label: AppStrings.issuePass,
                              ),
                            BottomNavigationBarItem(
                              icon: const ImageIcon(
                                AssetImage(AppIcon.tabProfile),
                              ),
                              label: AppStrings.profile,
                            ),
                          ],
                          currentIndex: controller.selectedIndex.value,
                          selectedItemColor: AppColors.blue,
                          onTap: _onItemTapped,
                        ),
                ))));
  }
}
