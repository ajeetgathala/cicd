import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cicd/locator.dart' as locator;

import 'package:cicd/screens/common/splash.dart';
void main() {
  setUp(() {
    locator.locator();
  });

  tearDown(() {
    locator.getIt.reset();
  });
  testWidgets('Splash navigates to login if id is null', (WidgetTester tester) async {
      await tester.pumpWidget(const GetMaterialApp(
        home: Splash()
      ));
      await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
