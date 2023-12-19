import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
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

  group('Notification settings screen Tests', () {
    test('Get Notification settings', () async {
      var userId = 0;
      var expectedResponse = [
        {
          "id": 8,
          "allNotifications": 1,
          "newPassNotifications": 1,
          "reminders": 1,
          "alerts": 1,
          "completed": 1,
          "departed": 1
        }
      ];

      when(() => mockHTTPClient.getNotificationSettings(userId))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getNotificationSettings(userId);
      expect(response.statusCode, 200);
    });
    test('Post Notification settings', () async {
      var request = {
        "userId": 0,
        "allNotifications": 0,
        "newPassNotifications": 0,
        "reminders": 0,
        "alerts": 0,
        "completed": 0,
        "departed": 0
      };
      var expectedResponse = {"id": 0};

      when(() => mockHTTPClient.postNotificationSetting(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postNotificationSetting(request);
      expect(response.statusCode, 200);
    });
  });
}
