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

  group('Location limit list screen Tests', () {
    test('Get Location limits list', () async {
      var expectedResponse = [
        {
          "id": 0,
          "expireDate": "0000-00-00",
          "passLimitId": 0,
          "passLimitValue": "0",
          "districtId": 0,
          "districtName": "district",
          "status": "status",
          "creator": "test teacher",
          "locationIdArr": "0,0",
          "locationNameArr": "location 1, location 2",
          "schoolIdArr": "0",
          "schoolNameArr": "Test School"
        }
      ];

      when(() => mockHTTPClient.getLocationLimits())
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getLocationLimits();
      expect(response.statusCode, 200);
    });
  });
}
