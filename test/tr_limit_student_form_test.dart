import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_limit_student_form_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  Get.testMode = true;
  late TrLimitStudentFormModel trLimitStudentFormModel;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    trLimitStudentFormModel = TrLimitStudentFormModel();
    mockHTTPClient = MockHTTPClient();
  });
  group('Limit student pass screen test', () {
    test('Add Limit student pass with valid data', () async {
      trLimitStudentFormModel.limit.value = 0;
      trLimitStudentFormModel.startDateApi.value = '0';
      trLimitStudentFormModel.endDateApi.value = '0';
      trLimitStudentFormModel.repetition.value = 0;
      trLimitStudentFormModel.reasonController.value.text = 't';

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: true, value: 1)
      ];
      List<int> selectedStudents = [];
      for (int i = 0; i < trLimitStudentFormModel.studentsList.length; i++) {
        if (trLimitStudentFormModel.studentsList[i].selected!) {
          selectedStudents.add(trLimitStudentFormModel.studentsList[i].value!);
        }
      }
      var request = {
        "passLimit": trLimitStudentFormModel.limit.value,
        "startDate": trLimitStudentFormModel.startDateApi.value,
        "endDate": trLimitStudentFormModel.endDateApi.value,
        "repetitionId": trLimitStudentFormModel.repetition.value,
        "reason": trLimitStudentFormModel.reasonController.value.text,
        "studentIdArr": selectedStudents.join(','),
        "districtId": ApiFilters.districtId
      };
      var expectedResponse = {
        "message": "Student pass limit created successfully",
        "id": null
      };

      when(() => mockHTTPClient.addLimitStudentPasses(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.addLimitStudentPasses(request);
      expect(response.statusCode, 200);
    });

    test('Edit Limit student pass with valid data', () async {
      trLimitStudentFormModel.limit.value = 0;
      trLimitStudentFormModel.startDateApi.value = '0';
      trLimitStudentFormModel.endDateApi.value = '0';
      trLimitStudentFormModel.repetition.value = 0;
      trLimitStudentFormModel.reasonController.value.text = 't';

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: true, value: 1)
      ];
      List<int> selectedStudents = [];
      for (int i = 0; i < trLimitStudentFormModel.studentsList.length; i++) {
        if (trLimitStudentFormModel.studentsList[i].selected!) {
          selectedStudents.add(trLimitStudentFormModel.studentsList[i].value!);
        }
      }
      var request = {
        "id": 0,
        "passLimit": trLimitStudentFormModel.limit.value,
        "startDate": trLimitStudentFormModel.startDateApi.value,
        "endDate": trLimitStudentFormModel.endDateApi.value,
        "repetitionId": trLimitStudentFormModel.repetition.value,
        "reason": trLimitStudentFormModel.reasonController.value.text,
        "studentIdArr": selectedStudents.join(','),
        "districtId": ApiFilters.districtId
      };
      var expectedResponse = {
        "message": "Student pass limit edited successfully",
        "id": null
      };

      when(() => mockHTTPClient.editLimitStudentPasses(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.editLimitStudentPasses(request);
      expect(response.statusCode, 200);
    });

    test('add or edit student pass limit when student is not selected',
        () async {
      trLimitStudentFormModel.limit.value = 0;
      trLimitStudentFormModel.startDateApi.value = '0';
      trLimitStudentFormModel.endDateApi.value = '0';
      trLimitStudentFormModel.repetition.value = 0;

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: false, value: 1)
      ];

      await trLimitStudentFormModel.validations();
      expect(trLimitStudentFormModel.studentError.value, true);
    });

    test('add or edit student pass limit when limit is not selected', () async {
      trLimitStudentFormModel.limit.text = '';
      trLimitStudentFormModel.startDateApi.value = '0';
      trLimitStudentFormModel.endDateApi.value = '0';
      trLimitStudentFormModel.repetition.value = 0;

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: true, value: 1)
      ];

      await trLimitStudentFormModel.validations();
      expect(trLimitStudentFormModel.limitError.value, true);
    });
    test('add or edit student pass limit when start date is not selected',
        () async {
      trLimitStudentFormModel.limit.text = 'limit';
      trLimitStudentFormModel.startDateApi.value = '';
      trLimitStudentFormModel.endDateApi.value = '0';
      trLimitStudentFormModel.repetition.value = 0;

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: true, value: 1)
      ];

      await trLimitStudentFormModel.validations();
      expect(trLimitStudentFormModel.startDateError.value, true);
    });
    test('add or edit student pass limit when end date is not selected',
        () async {
      trLimitStudentFormModel.limit.text = 'limit';
      trLimitStudentFormModel.startDateApi.value = '00/00/0000';
      trLimitStudentFormModel.endDateApi.value = '';
      trLimitStudentFormModel.repetition.value = 0;

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: true, value: 1)
      ];

      await trLimitStudentFormModel.validations();
      expect(trLimitStudentFormModel.entDateError.value, true);
    });
    test('add or edit student pass limit when repetition is not selected',
        () async {
      trLimitStudentFormModel.limit.text = 'limit';
      trLimitStudentFormModel.startDateApi.value = '00/00/0000';
      trLimitStudentFormModel.endDateApi.value = '00/00/0000';
      trLimitStudentFormModel.repetition.text = '';

      trLimitStudentFormModel.studentsList = [
        ValueTextModel(selected: true, value: 1)
      ];

      await trLimitStudentFormModel.validations();
      expect(trLimitStudentFormModel.repetitionError.value, true);
    });
  });
}
