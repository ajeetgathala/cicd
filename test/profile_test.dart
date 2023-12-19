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

  group('Profile screen Tests', () {
    test('Get Profile', () async {
      var id = 0;
      var expectedResponse = {
        "id": 0,
        "employeeId": '',
        "studentIdNumber": '',
        "firstName": "first name",
        "lastName": "last name",
        "userName": "test@domain.com",
        "email": 'test@domain.com',
        "imagePath": '',
        "phone": "0000000000",
        "comments": 'comment',
        "userTypeId": 0,
        "permissionGroupId": '',
        "status": 0,
        "districtId": 0,
        "ePassMaxTime": 0,
        "privilegeFirst": 0000000000,
        "privilegeSecond": 0000000000,
        "privilegeThird": 0000000000,
        "permission": 0,
        "schoolIdArr": '0,0'
      };

      when(() => mockHTTPClient.getProfile(id)).thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getProfile(id);
      expect(response.statusCode, 200);
    });

    test('Update Profile', () async {
      var id = 0;
      var image = 'image path';
      var expectedResponse = {"id": 0};

      when(() => mockHTTPClient.updateProfile(id, image))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.updateProfile(id, image);
      expect(response.statusCode, 200);
    });

    test('Post token Profile', () async {
      var request = {"userId": 0, "registrationToken": 'token'};
      var expectedResponse = {"id": 0};
      when(() => mockHTTPClient.postFcmToken(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postFcmToken(request);
      expect(response.statusCode, 200);
    });

    test('Logout', () async {
      var expectedResponse = {"id": 0};
      when(() => mockHTTPClient.getLogout()).thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getLogout();
      expect(response.statusCode, 200);
    });
  });
}
