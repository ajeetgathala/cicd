import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/student_ui_controllers/st_new_request_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  Get.testMode = true;
  late StNewRequestModel requestPassModel;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    requestPassModel = StNewRequestModel();
    mockHTTPClient = MockHTTPClient();
  });
  group('Issue pass', () {
    test('Issue pass with valid data', () async {
      requestPassModel.departing.value = 0;
      requestPassModel.destination.value = 0;
      requestPassModel.destination.ePassExpiredTime = '0';
      requestPassModel.teacherDeparting.value = 0;
      requestPassModel.teacherDestination.value = 0;
      requestPassModel.selectedTimeApi.value = '00:00:00';
      requestPassModel.commentController.value.text = 'Comment';

      var request = {
        "studentId": 0,
        "departingLocationId": requestPassModel.departing.type,
        "departingTeacherId": requestPassModel.teacherDeparting.value,
        "destinationTeacherId": requestPassModel.teacherDestination.value,
        "destinationLocationId": requestPassModel.destination.value,
        "outTime": requestPassModel.selectedTimeApi.value,
        "comment": requestPassModel.commentController.value.text,
        "ePassTimeId": requestPassModel.destination.ePassExpiredTime
      };
      var expectedResponse = {
        "message": "Pass created successfully",
        "id": null
      };

      when(() => mockHTTPClient.requestNewPass(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.requestNewPass(request);
      expect(response.statusCode, 200);
    });

    test('issue pass when departing teacher is not selected', () async {
      requestPassModel.departing.type = AppStrings.location;
      requestPassModel.departing.text = '';
      requestPassModel.destination.value = 0;
      requestPassModel.teacherDeparting.text = '';
      requestPassModel.teacherDestination.value = 0;
      requestPassModel.selectedTimeApi.value = '00:00:00';
      requestPassModel.commentController.value.text = 'Comment';
      requestPassModel.postRequest();
      expect(requestPassModel.teacherFromError.value, true);
    });
    test('issue pass when departing location is not selected', () async {
      requestPassModel.departing.type = '';
      requestPassModel.destination.text = '';
      requestPassModel.teacherDeparting.text = 'Teacher';
      requestPassModel.teacherDestination.text = '';
      requestPassModel.selectedTimeApi.value = '00:00:00';
      requestPassModel.commentController.value.text = 'Comment';
      requestPassModel.postRequest();
      expect(requestPassModel.departError.value, true);
    });
    test(
        'issue pass when destination location or destination teacher is not selected',
        () async {
      requestPassModel.departing.type = AppStrings.teacher;
      requestPassModel.departing.text = AppStrings.teacher;
      requestPassModel.destination.text = '';
      requestPassModel.teacherDeparting.text = 'Teacher';
      requestPassModel.teacherDestination.text = '';
      requestPassModel.selectedTimeApi.value = '00:00:00';
      requestPassModel.commentController.value.text = 'Comment';
      requestPassModel.postRequest();
      expect(requestPassModel.teacherToError.value, true);
    });

    test('issue pass when E-Pass time is not selected', () async {
      requestPassModel.departing.type = AppStrings.teacher;
      requestPassModel.departing.text = AppStrings.teacher;
      requestPassModel.destination.text = 'destination';
      requestPassModel.teacherDeparting.text = 'Teacher';
      requestPassModel.teacherDestination.text = 'destination teacher';
      requestPassModel.selectedTimeApi.value = AppStrings.selectTime;
      requestPassModel.commentController.value.text = 'Comment';
      requestPassModel.postRequest();
      expect(requestPassModel.timeError.value, true);
    });
  });
}
