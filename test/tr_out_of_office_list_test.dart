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

  group('Out of office list screen Tests', () {
    test('Get Out of office list', () async {
      var expectedResponse = [
        {
          "id": 0,
          "title": "Test title",
          "presets": 0,
          "startDate": "0000-00-00",
          "startTime": "00:00:00",
          "endTime": "00:00:00",
          "repetition": "repetition",
          "reason": "",
          "status": "status",
          "creator": 0,
          "creationDate": "0000-00-00T00:00:00.00",
          "modifier": null,
          "modifyDate": null,
          "teacherId": 0,
          "teacherName": "teacher name",
          "districtId": 0,
          "districtName": "District",
          "schoolId": "0",
          "schoolName": "test School"
        }
      ];

      when(() => mockHTTPClient.getOutOfOfficeList())
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getOutOfOfficeList();
      expect(response.statusCode, 200);
    });
  });
}
