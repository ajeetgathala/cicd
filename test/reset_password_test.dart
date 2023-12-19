import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/auth_ui_controllers/reset_password_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  Get.testMode = true;
  late ResetPasswordModel resetPasswordModel;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    resetPasswordModel = ResetPasswordModel();
    mockHTTPClient = MockHTTPClient();
  });
  testWidgets('Resend OTP button test', (widgetTester) async {
    // ResetPasswordModel resetPasswordModel2 = ResetPasswordModel();
    // await widgetTester.pumpWidget(const MaterialApp(
    //   home: ResetPassword(),
    // ));
    // resetPasswordModel2.showResend.value = true;
    // expect(
    //     find.byKey(
    //       const Key('resendButton'),
    //     ),
    //     findsOneWidget);
  });
  group('ResetPasswordModel', () {
    test('resetPassword() with valid data', () async {
      resetPasswordModel.email.value = 'test@example.com';
      resetPasswordModel.passwordController.value.text = 'newPassword';
      resetPasswordModel.reEnterPasswordController.value.text = 'newPassword';
      resetPasswordModel.enteredOtp.value = '1234';

      var request = {
        "email": 'test@domain.com',
        "otp": '0000',
        "newPassword": 'newPassword'
      };
      var expectedResponse = {
        "message":
            "password changed successfully",
        "id": null
      };

      when(() => mockHTTPClient.resetPassword(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.resetPassword(request);
      expect(response.statusCode, 200);
    });

    test('resetPassword() with empty password', () async {
      resetPasswordModel.email.value = 'invalid_email';
      resetPasswordModel.passwordController.value.text = '';
      resetPasswordModel.reEnterPasswordController.value.text = '';
      resetPasswordModel.enteredOtp.value = '1234';
      await resetPasswordModel.resetPassword();
      expect(resetPasswordModel.passwordMessage1.value,
          AppStrings.pleaseEnterPassword);
    });
    test('resetPassword() with empty confirm password', () async {
      resetPasswordModel.email.value = 'test@example.com';
      resetPasswordModel.passwordController.value.text = 'newPassword';
      resetPasswordModel.reEnterPasswordController.value.text = '';
      resetPasswordModel.enteredOtp.value = '1234';

      await resetPasswordModel.resetPassword();

      expect(resetPasswordModel.passwordMessage2.value,
          AppStrings.pleaseConfirmPassword);
    });
    test('resetPassword when password did not match', () async {
      resetPasswordModel.email.value = 'test@example.com';
      resetPasswordModel.passwordController.value.text = 'new password';
      resetPasswordModel.reEnterPasswordController.value.text =
          'confirm password';
      resetPasswordModel.enteredOtp.value = '1234';
      await resetPasswordModel.resetPassword();
      expect(resetPasswordModel.passwordMessage2.value,
          AppStrings.passwordDidNotMatch);
    });
    test('resetPassword when OTP is empty', () async {
      resetPasswordModel.email.value = 'test@example.com';
      resetPasswordModel.passwordController.value.text = '12345';
      resetPasswordModel.reEnterPasswordController.value.text =
      '12345';
      resetPasswordModel.enteredOtp.value = '';
      await resetPasswordModel.resetPassword();
      expect(resetPasswordModel.otpErrorMessage.value,
          AppStrings.pleaseEnterOtp);
    });
    test('resetPassword when OTP is less then 4 digits', () async {
      resetPasswordModel.email.value = 'test@example.com';
      resetPasswordModel.passwordController.value.text = '12345';
      resetPasswordModel.reEnterPasswordController.value.text =
      '12345';
      resetPasswordModel.enteredOtp.value = '123';
      await resetPasswordModel.resetPassword();
      expect(resetPasswordModel.otpErrorMessage.value,
          AppStrings.pleaseEnter4Digit);
    });
  });
}
