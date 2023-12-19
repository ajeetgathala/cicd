import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/auth_ui_controllers/forgot_password_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    mockHTTPClient = MockHTTPClient();
  });

  group('ForgotPasswordModel Tests', () {
    test('Send OTP with a valid email', () async {
      var request = {
        "email": 'abc@xyz.com',
      };
      final viewModel = ForgotPasswordModel();

      viewModel.emailController.value.text = 'valid@example.com';
      var expectedResponse = {
        "message":
            "You have accessed the linked E-Pass from your email cena@mailinator.com, for which One Time Password (OTP) has been generated and sent to your registered email cena@mailinator.com.",
        "id": null
      };

      when(() => mockHTTPClient.sendOtpForPassword(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.sendOtpForPassword(request);

      expect(response.statusCode, 200);
    });

    test('Send OTP with valid email', () async {
      final viewModel = ForgotPasswordModel();
      viewModel.emailController.value.text = 'abc@xyz.com';
      viewModel.sendOtp();
      expect(viewModel.sendingOtp.value, true);
      expect(viewModel.emailMessage.value, AppStrings.pleaseEnterEmail);
    });

    test('Send OTP with empty email', () async {
      final viewModel = ForgotPasswordModel();
      viewModel.emailController.value.text = '';
      viewModel.sendOtp();
      expect(viewModel.emailError.value, true);
      expect(viewModel.emailMessage.value, AppStrings.pleaseEnterEmail);
    });

    test('Send OTP with a invalid email', () async {
      final viewModel = ForgotPasswordModel();
      viewModel.emailController.value.text = 'invalid_email';
      viewModel.sendOtp();
      expect(viewModel.emailError.value, true);
      expect(viewModel.emailMessage.value, AppStrings.pleaseEnterValidEmail);
    });
  });
}
