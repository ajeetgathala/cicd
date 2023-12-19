import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/common_ui_controllers/pass_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late MockHTTPClient mockHTTPClient;
  late PassDetailModel passDetailModel;
  setUp(() {
    locator();
    mockHTTPClient = MockHTTPClient();
    passDetailModel = PassDetailModel();
  });

  group('Pass detail screen Tests', () {
    test('Get Pass detail list', () async {
      var id = 0;
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
          "destinationTeacherImage": "",
          "issueTime": "Mmm 00 0000  00:00PM",
          "outTime": "Mmm 00 0000  00:00PM",
          "inTime": "",
          "diffTime": "",
          "comment": "",
          "status": 0,
          "statusText": "status",
          "districtId": 0,
          "schoolId": "0",
          "locationId": "0",
          "studentId": 0,
          "studentName": "test student",
          "creatorId": 0,
          "creatorName": "test teacher",
          "journeyTimeId": 0,
          "journeyTime": "1 Min",
          "ePassTimeId": 0,
          "ePassTime": "3 Min",
          "departedBy": "To",
          "departedTime": "00-00-0000 00:00:00",
          "receivedTime": "00-00-0000 00:00:00",
          "approvedTime": "00-00-0000 00:00:00",
          "todayCount": 0,
          "validationType": "0",
          "validationText": "validation text"
        }
      ];

      when(() => mockHTTPClient.getPassById(id)).thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.getPassById(id);
      expect(response.statusCode, 200);
    });

    test('approve pass', () async {
      passDetailModel.journeyTime.value = 0;
      passDetailModel.stPassesListDataModel.destinationTeacherId = 1;
      await passDetailModel.postApproval();
      expect(passDetailModel.journeyTimeError.value, true);

      passDetailModel.journeyTime.value = 0;
      passDetailModel.stPassesListDataModel.destinationTeacherId = 0;
      passDetailModel.ePassTime.value = 0;
      await passDetailModel.postApproval();
      expect(passDetailModel.ePassTimeError.value, true);

      passDetailModel.ePassTime.value = 1;
      await passDetailModel.postApproval();
      expect(passDetailModel.journeyTimeError.value, false);
      expect(passDetailModel.ePassTimeError.value, false);

      var id =
          '?id=0&journeyTimeId=${passDetailModel.journeyTime.value}&ePassTimeId=${passDetailModel.ePassTime.value}';
      var expectedResponse = {"id": 0};
      when(() => mockHTTPClient.postApproval(id))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postApproval(id);
      expect(response.statusCode, 200);
    });

    test('reject pass', () async {
      var id = '?id=0';
      var expectedResponse = {"id": 0};

      when(() => mockHTTPClient.postRejection(id))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postRejection(id);
      expect(response.statusCode, 200);
    });

    test('receive pass', () async {
      var id = '?id=0&ePassTimeId=0';
      var expectedResponse = {"id": 0};
      when(() => mockHTTPClient.postReceived(id))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postReceived(id);
      expect(response.statusCode, 200);
    });

    test('send back pass', () async {
      passDetailModel.journeyTime.value = 0;
      await passDetailModel.postDeparted();
      expect(passDetailModel.journeyTimeError.value, true);

      var id = '?id=0&journeyTimeId=${passDetailModel.ePassTime.value}';
      var expectedResponse = {"id": 0};

      when(() => mockHTTPClient.postDeparted(id))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postDeparted(id);
      expect(response.statusCode, 200);
    });

    test('complete pass', () async {
      var id = '?id=0';
      var expectedResponse = {"id": 0};
      when(() => mockHTTPClient.postEnd(id)).thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.postEnd(id);
      expect(response.statusCode, 200);
    });
  });
}
