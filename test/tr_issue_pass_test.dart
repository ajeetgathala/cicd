import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_issue_pass_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  Get.testMode = true;
  late TrIssuePassModel issuePassModel;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    issuePassModel = TrIssuePassModel();
    mockHTTPClient = MockHTTPClient();
  });
  group('Issue pass', () {
    test('Issue pass with valid data', () async {
      issuePassModel.student.value = 0;
      issuePassModel.departing.value = 0;
      issuePassModel.destination.value = 0;
      issuePassModel.teacherDeparting.value = 0;
      issuePassModel.teacherDestination.value = 0;
      issuePassModel.selectedTimeApi.value = '00:00:00';
      issuePassModel.journeyTime.value = 0;
      issuePassModel.ePassTime.value = 0;
      issuePassModel.commentController.value.text = 'Comment';

      var request = {
        "studentId": issuePassModel.student.value,
        "departingLocationId": issuePassModel.departing.value,
        "departingTeacherId": issuePassModel.teacherDeparting.value,
        "destinationLocationId": issuePassModel.destination.value,
        "destinationTeacherId": issuePassModel.teacherDestination.value,
        "outTime": issuePassModel.selectedTimeApi.value,
        "journeyTimeId": issuePassModel.journeyTime.value,
        "ePassTimeId": issuePassModel.ePassTime.value,
        "comment": issuePassModel.commentController.value.text
      };
      var expectedResponse = {
        "message": "Pass created successfully",
        "id": null
      };

      when(() => mockHTTPClient.addNewPass(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.addNewPass(request);
      expect(response.statusCode, 200);
    });

    test('issue pass when student is not selected', () async {
      issuePassModel.student.text = '';
      issuePassModel.departing.value = 0;
      issuePassModel.destination.value = 0;
      issuePassModel.teacherDeparting.value = 0;
      issuePassModel.teacherDestination.value = 0;
      issuePassModel.selectedTimeApi.value = '00:00:00';
      issuePassModel.journeyTime.value = 0;
      issuePassModel.ePassTime.value = 0;
      issuePassModel.commentController.value.text = 'Comment';
      await issuePassModel.validate();
      expect(issuePassModel.studentError.value, true);
    });

    test('issue pass when departing teacher is not selected', () async {
      issuePassModel.student.text = 'Student';
      issuePassModel.departing.type = AppStrings.location;
      issuePassModel.departing.text = '';
      issuePassModel.destination.value = 0;
      issuePassModel.teacherDeparting.text = '';
      issuePassModel.teacherDestination.value = 0;
      issuePassModel.selectedTimeApi.value = '00:00:00';
      issuePassModel.journeyTime.value = 0;
      issuePassModel.ePassTime.value = 0;
      issuePassModel.commentController.value.text = 'Comment';
      await issuePassModel.validate();
      expect(issuePassModel.teacherDepartingError.value, true);
    });
    test(
        'issue pass when destination location or destination teacher is not selected',
            () async {
          issuePassModel.student.text = 'Student';
          issuePassModel.departing.type = AppStrings.location;
          issuePassModel.destination.text = '';
          issuePassModel.teacherDeparting.text = 'Teacher';
          issuePassModel.teacherDestination.text = '';
          issuePassModel.selectedTimeApi.value = '00:00:00';
          issuePassModel.journeyTime.value = 0;
          issuePassModel.ePassTime.value = 0;
          issuePassModel.commentController.value.text = 'Comment';
          await issuePassModel.validate();
          expect(issuePassModel.teacherDestinationError.value, true);
        });
    test(
        'issue pass when journey time is not selected',
            () async {
          issuePassModel.student.text = 'Student';
          issuePassModel.departing.type = AppStrings.location;
          issuePassModel.destination.text = 'destination';
          issuePassModel.teacherDeparting.text = 'Teacher';
          issuePassModel.teacherDestination.text = 'Teacher destination';
          issuePassModel.teacherDestination.value = 0;
          issuePassModel.selectedTimeApi.value = '00:00:00';
          issuePassModel.journeyTime.text = '';
          issuePassModel.ePassTime.value = 0;
          issuePassModel.commentController.value.text = 'Comment';
          await issuePassModel.validate();
          expect(issuePassModel.journeyTimeError.value, true);
        });
    test(
        'issue pass when E-Pass time is not selected',
            () async {
          issuePassModel.student.text = 'Student';
          issuePassModel.departing.type = AppStrings.location;
          issuePassModel.destination.text = 'destination';
          issuePassModel.teacherDeparting.text = 'Teacher';
          issuePassModel.teacherDestination.text = 'Teacher destination';
          issuePassModel.teacherDestination.value = 0;
          issuePassModel.selectedTimeApi.value = '00:00:00';
          issuePassModel.journeyTime.text = '00:00:00';
          issuePassModel.ePassTime.text = '';
          issuePassModel.commentController.value.text = 'Comment';
          await issuePassModel.validate();
          expect(issuePassModel.ePassTimeError.value, true);
        });
  });
}
