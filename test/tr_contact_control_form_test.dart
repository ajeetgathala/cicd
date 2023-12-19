import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_contact_control_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late MockHTTPClient mockHTTPClient;
  late TrContactControlFromModel trContactControlFromModel;
  setUp(() {
    locator();
    trContactControlFromModel = TrContactControlFromModel();
    mockHTTPClient = MockHTTPClient();
  });

  group('Contact control list screen Tests', () {
    test('Add Contact control', () async {
      var request = {
        "adminOnlyNote": 'note',
        "expireDate": '00-00-0000',
        "expireTime": '00:00',
        "studentIdArr": '0,0',
        "locationIdArr": '0,0',
        "districtId": '0'
      };
      var expectedResponse = [
        {
          "message": "added successfully"
        }
      ];

      when(() => mockHTTPClient.addContactControl(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.addContactControl(request);
      expect(response.statusCode, 200);
    });

    test('Edit Contact control', () async {
      var request = {
        "id": '0',
        "adminOnlyNote": 'note',
        "expireDate": '00-00-0000',
        "expireTime": '00:00',
        "studentIdArr": '0,0',
        "locationIdArr": '0,0',
        "districtId": '0'
      };
      var expectedResponse = [
        {
          "message": "edited successfully"
        }
      ];

      when(() => mockHTTPClient.editContactControl(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.editContactControl(request);
      expect(response.statusCode, 200);
    });

    test('add or edit without student', () {
      trContactControlFromModel.studentsList = [
        ValueTextModel(selected: false),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.validations();
      expect(trContactControlFromModel.studentError.value, true);
    });
    test('add or edit without location', () {
      trContactControlFromModel.studentsList = [
        ValueTextModel(selected: true),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.locationsList = [
        ValueTextModel(selected: false),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.validations();
      expect(trContactControlFromModel.locationError.value, true);
    });
    test('add or edit without expiry date', () {
      trContactControlFromModel.studentsList = [
        ValueTextModel(selected: true),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.locationsList = [
        ValueTextModel(selected: true),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.selectedDateApi.value = '';
      trContactControlFromModel.validations();
      expect(trContactControlFromModel.expiryError.value, true);
    });
    test('add or edit without expiry time', () {
      trContactControlFromModel.studentsList = [
        ValueTextModel(selected: true),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.locationsList = [
        ValueTextModel(selected: true),
        ValueTextModel(selected: false)
      ];
      trContactControlFromModel.selectedDateApi.value = 'date';
      trContactControlFromModel.selectedTimeApi.value = '';
      trContactControlFromModel.validations();
      expect(trContactControlFromModel.timeError.value, true);
    });
  });
}
