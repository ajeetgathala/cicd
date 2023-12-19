import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_out_of_office_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  Get.testMode = true;
  late TrOutOfOfficeModel trOutOfOfficeModel;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    trOutOfOfficeModel = TrOutOfOfficeModel();
    mockHTTPClient = MockHTTPClient();
  });
  group('Out of office screen test', () {
    test('Add out of office with valid data', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.value = 0;
      trOutOfOfficeModel.preset.value = 0;
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      var request = {
        "title": trOutOfOfficeModel.titleController.value.text,
        "teacherId": trOutOfOfficeModel.teacher.value,
        "presets": trOutOfOfficeModel.preset.value.toString(),
        "startTime": trOutOfOfficeModel.startTimeApi.value,
        "endTime": trOutOfOfficeModel.endTimeApi.value,
        "startDate": trOutOfOfficeModel.selectedDateApi.value,
        "repetition": trOutOfOfficeModel.repetition.value.toString(),
        "reason": trOutOfOfficeModel.reasonController.value.text
      };
      var expectedResponse = {
        "message": "Location limit created successfully",
        "id": null
      };

      when(() => mockHTTPClient.addOutOfOffice(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.addOutOfOffice(request);
      expect(response.statusCode, 200);
    });

    test('Edit out of office valid data', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.value = 0;
      trOutOfOfficeModel.preset.value = 0;
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      var request = {
        "id": 0,
        "title": trOutOfOfficeModel.titleController.value.text,
        "teacherId": trOutOfOfficeModel.teacher.value,
        "presets": trOutOfOfficeModel.preset.value.toString(),
        "startTime": trOutOfOfficeModel.startTimeApi.value,
        "endTime": trOutOfOfficeModel.endTimeApi.value,
        "startDate": trOutOfOfficeModel.selectedDateApi.value,
        "repetition": trOutOfOfficeModel.repetition.value.toString(),
        "reason": trOutOfOfficeModel.reasonController.value.text
      };
      var expectedResponse = {
        "message": "Location limit edited successfully",
        "id": null
      };

      when(() => mockHTTPClient.editOutOfOffice(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.editOutOfOffice(request);
      expect(response.statusCode, 200);
    });

    test('add or edit Out of office when Title is not selected', () async {
      trOutOfOfficeModel.titleController.value.text = '';
      trOutOfOfficeModel.teacher.value = 0;
      trOutOfOfficeModel.preset.value = 0;
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      await trOutOfOfficeModel.validations();
      expect(trOutOfOfficeModel.titleError.value, true);
    });

    test('add or edit Out of office when preset is not selected', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.value = 0;
      trOutOfOfficeModel.preset.text = '';
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      await trOutOfOfficeModel.validations();
      expect(trOutOfOfficeModel.presetsError.value, true);
    });
    test('add or edit Out of office when date is not selected', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.value = 0;
      trOutOfOfficeModel.preset.text = 'preset';
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      await trOutOfOfficeModel.validations();
      expect(trOutOfOfficeModel.dateError.value, true);
    });
    test('add or edit Out of office when start time is not selected', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.value = 0;
      trOutOfOfficeModel.preset.text = 'preset';
      trOutOfOfficeModel.startTimeApi.value = '';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      await trOutOfOfficeModel.validations();
      expect(trOutOfOfficeModel.startTimeError.value, true);
    });
    test('add or edit Out of office when teacher is not selected', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.text = '';
      trOutOfOfficeModel.preset.text = 'preset';
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.value = 0;
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      await trOutOfOfficeModel.validations();
      expect(trOutOfOfficeModel.teacherError.value, true);
    });
    test('add or edit Out of office when repetition is not selected', () async {
      trOutOfOfficeModel.titleController.value.text = 'title';
      trOutOfOfficeModel.teacher.text = 'teacher';
      trOutOfOfficeModel.preset.text = 'preset';
      trOutOfOfficeModel.startTimeApi.value = '00:00';
      trOutOfOfficeModel.endTimeApi.value = '00:00';
      trOutOfOfficeModel.selectedDateApi.value = '00/00/0000';
      trOutOfOfficeModel.repetition.text = '';
      trOutOfOfficeModel.reasonController.value.text = 'reason';
      await trOutOfOfficeModel.validations();
      expect(trOutOfOfficeModel.repetitionError.value, true);
    });
  });
}
