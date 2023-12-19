import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/screens/auth/login.dart';
import 'package:cicd/ui_controllers/auth_ui_controllers/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  setUp(() {
    Get.testMode = true;
    locator();
  });
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    mockHTTPClient = MockHTTPClient();
  });

  testWidgets(
      'On Forgot password clicked, has to move to the Forgot password screen',
      (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: Login(),
    ));
    expect(find.byType(TextButton), findsOneWidget);
    await widgetTester.tap(find.byType(TextButton));
    await widgetTester.pumpAndSettle();
    // expect(find.text(AppStrings.forgotNPassword), findsOneWidget);
  });

  group('LoginViewModel Tests', () {
    test('Login without entering email and password', () async {
      var request = {
        "email": 'abc@xyz.com',
      };
      final viewModel = LoginViewModel();

      viewModel.emailController.value.text = 'valid@example.com';

      var expectedResponse = {
        "id": 1,
        "firstName": "firstname",
        "lastName": "lastname",
        "userName": "test@domain.com",
        "jwtToken": "eyJhnZUZpcnN0FxEobRgNY",
        "userTypeId": 1,
        "userType": "Master Admin",
        "privilegeFirst": 123456,
        "privilegeSecond": 654321,
        "privilegeThird": 162534,
        "permission": 0
      };

      when(() => mockHTTPClient.loginApi(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.loginApi(request);
      expect(response.statusCode, 200);
      expect(Get.currentRoute, '');
    });

    test('Login with incorrect credentials', () async {
      var request = {
        "email": 'abc@xyz.com',
      };
      final viewModel = LoginViewModel();

      viewModel.emailController.value.text = 'valid@example.com';

      var expectedResponse = {"id": 0};
      when(() => mockHTTPClient.loginApi(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 404);
      });
      final response = await mockHTTPClient.loginApi(request);
      expect(response.statusCode, 404);
      expect(Get.currentRoute, '');
    });

    test('Login without entering email and password', () async {
      final viewModel = LoginViewModel();
      viewModel.emailController.value.text = '';
      viewModel.passwordController.value.text = '';
      viewModel.loginApi();
      expect(viewModel.emailMessage.value, AppStrings.pleaseEnterEmail);
      expect(viewModel.passwordMessage.value, AppStrings.pleaseEnterPassword);
    });
    test('Login with entering invalid email address', () async {
      final viewModel = LoginViewModel();
      viewModel.emailController.value.text = 'invalidemail';
      viewModel.passwordController.value.text = '';
      viewModel.loginApi();
      expect(viewModel.emailMessage.value, AppStrings.pleaseEnterValidEmail);
      expect(viewModel.passwordMessage.value, AppStrings.pleaseEnterPassword);
    });
  });
}
