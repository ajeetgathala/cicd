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
          "departingLocationId": 0,
          "departingLocationName": "",
          "departingLocationImage": "",
          "departingTeacherId": 0,
          "departingTeacherName": "test teacher",
          "departingTeacherImage": "",
          "destinationLocationId": 0,
          "destinationLocationName": "test",
          "destinationLocationImage": "",
          "destinationTeacherId": 0,
          "destinationTeacherName": "test teacher",
          "destinationTeacherImage": "image",
          "issueTime": "Mmm 00 0000 00:00AA",
          "outTime": "Mmm 00 0000 00:00AA",
          "inTime": null,
          "diffTime": null,
          "comment": "string",
          "status": 0,
          "statusText": "Alert",
          "districtId": 0,
          "schoolId": "0",
          "locationId": "0",
          "studentId": 0,
          "studentName": "test student",
          "creatorId": 0,
          "creatorName": "test creator",
          "journeyTimeId": 0,
          "journeyTime": "0 Min",
          "ePassTimeId": 0,
          "ePassTime": "0 Min",
          "departedBy": "To",
          "departedTime": "0000-00-00 00:00:00",
          "receivedTime": "0000-00-00 00:00:00",
          "approvedTime": "0000-00-00 00:00:00",
          "todayCount": 0,
          "validationType": "0",
          "validationText": "validation text"
        }
      ];

      when(() => mockHTTPClient.getPasses()).thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getPasses();
      expect(response.statusCode, 200);
    });
  });
}
