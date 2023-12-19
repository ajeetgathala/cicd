import 'package:cicd/constants/app_colors.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/constants/const_assets.dart';
import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/screens/teacher/tr_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_home_model.dart';
import 'package:get/get.dart';

void main() {
  Get.testMode = true;
  locator();
  var trHomeModel = TrHomeModel();

  testWidgets('Clicking on a list item in TrHome', (WidgetTester tester) async {
    Future<List<ListData>> fetchHomeData() async {
      return [
        ListData(
            AppStrings.activePasses, AppIcon.activePass, '', AppColors.yellow),
        ListData(AppStrings.locationLimit, AppIcon.locationLimit, '',
            AppColors.orange),
        ListData(
            AppStrings.outOfOffice, AppIcon.outOfOffice, '', AppColors.pink),
        ListData(AppStrings.limitStudentPasses, AppIcon.limitStudent, '',
            AppColors.greenCardBg),
        ListData(AppStrings.contactControl, AppIcon.contactControl, '',
            AppColors.purple)
      ].obs;
    }

    SessionKeys.typeId = 4;

    trHomeModel.data = await fetchHomeData();
    await tester.pumpWidget(const MaterialApp(
      home: TrHome(),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Expanded), findsOneWidget);
    expect(find.byKey(const Key('homeList')), findsOneWidget);
    for (int i = 0; i < trHomeModel.data.length; i++) {
      expect(find.text(trHomeModel.data[i].name), findsOneWidget);
      await tester.tap(find.byKey(Key('item$i')));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '');

      // if (i == 0) {
      //   expect(Get.currentRoute, Routes.trPasses);
      // } else if (i == 1) {
      //   expect(Get.currentRoute, Routes.trLocationLimit);
      // } else if (i == 2) {
      //   expect(Get.currentRoute, Routes.trOutOfOfficeList);
      // } else if (i == 3) {
      //   expect(Get.currentRoute, Routes.trLimitStudent);
      // } else if (i == 4) {
      //   expect(Get.currentRoute, Routes.trContactControl);
      // }
    }
  });
}
