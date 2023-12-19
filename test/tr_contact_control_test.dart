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

  group('Contact control list screen Tests', () {
    test('Get Contact control list', () async {
      var expectedResponse = [
        {
          "id": 0,
          "expireDate": "0000-00-00",
          "expireTime": "00:00:00",
          "adminOnlyNote": "",
          "timesTriggered": 0,
          "status": "status",
          "districtId": 0,
          "districtName": "district name",
          "schoolId": "0",
          "schoolName": "School name",
          "studentId": "0",
          "studentName": "test student",
          "locationId": "0",
          "locationName": "location",
          "creator": "test teacher",
          "creationDate": "0000-00-00T00:00:00.000",
          "modifier": "modifier",
          "modifyDate": "0000-00-00T00:00:00.00"
        }
      ];

      when(() => mockHTTPClient.getContactControlList())
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getContactControlList();
      expect(response.statusCode, 200);
    });
  });
}
