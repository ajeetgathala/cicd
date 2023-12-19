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

  group('Notifications and alerts list screen Tests', () {
    test('Get Notifications list', () async {
      var userId = 0;
      var expectedResponse = [
        {
          "id": 0,
          "entryDate": "00/00/0000 00:00",
          "typeName": "Type",
          "typeId": 0,
          "title": "title",
          "message": "notification message"
        }
      ];

      when(() => mockHTTPClient.getNotifications(userId))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getNotifications(userId);
      expect(response.statusCode, 200);
    });

    test('Get Alerts list', () async {
      var ePassId = 0;
      var expectedResponse = [
        {
          "id": 0,
          "entryDate": "00/00/0000 00:00",
          "typeName": "Type",
          "typeId": 0,
          "title": "title",
          "message": "notification message"
        }
      ];

      when(() => mockHTTPClient.getAlerts(ePassId))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getAlerts(ePassId);
      expect(response.statusCode, 200);
    });
  });
}
