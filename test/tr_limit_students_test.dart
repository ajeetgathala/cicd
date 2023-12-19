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

  group('Student pass limit list screen Tests', () {
    test('Get Student pass limits list', () async {
      var expectedResponse = [
        {
          "id": 0,
          "districtId": 0,
          "districtName": "test District",
          "startDate": "0000-00-00",
          "endDate": "0000-00-00",
          "passLimitId": 0,
          "passLimitValue": "0",
          "repetitionId": 0,
          "repetition": "Repetition",
          "reason": "",
          "status": "status",
          "schoolId": "0",
          "schoolName": "test School",
          "studentIdArr": "0",
          "studentNameArr": "student",
          "comments": ""
        }
      ];

      when(() => mockHTTPClient.getLimitStudentPasses())
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getLimitStudentPasses();
      expect(response.statusCode, 200);
    });
  });
}
