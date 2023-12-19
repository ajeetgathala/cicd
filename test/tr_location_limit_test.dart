import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/common_models/value_text_model.dart';
import 'package:cicd/ui_controllers/teacher_ui_controllers/tr_location_limit_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHTTPClient extends Mock implements Repositories {}

void main() {
  Get.testMode = true;
  late TrLocationLimitModel trLocationLimitModel;
  late MockHTTPClient mockHTTPClient;
  setUp(() {
    locator();
    trLocationLimitModel = TrLocationLimitModel();
    mockHTTPClient = MockHTTPClient();
  });
  group('Location Limit screen test', () {
    test('Add location limit with valid data', () async {
      trLocationLimitModel.limit.value = 0;
      trLocationLimitModel.selectedDatePost.value = '0';
      trLocationLimitModel.locationsList = [
        ValueTextModel(selected: true, value: 0)
      ];
      List<int> selectedItems = [];
      for (int i = 0; i < trLocationLimitModel.locationsList.length; i++) {
        if (trLocationLimitModel.locationsList[i].selected!) {
          selectedItems.add(trLocationLimitModel.locationsList[i].value!);
        }
      }
      var request = {
        "limit": trLocationLimitModel.limit.value,
        "expireDate": trLocationLimitModel.selectedDatePost.value,
        "locationIdArr": selectedItems.join(','),
        "districtId": ApiFilters.getDistrictId()
      };
      var expectedResponse = {
        "message": "Location limit created successfully",
        "id": null
      };

      when(() => mockHTTPClient.addLocationLimit(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.addLocationLimit(request);
      expect(response.statusCode, 200);
    });

    test('Edit location limit with valid data', () async {
      trLocationLimitModel.limit.value = 0;
      trLocationLimitModel.selectedDatePost.value = '0';
      trLocationLimitModel.locationsList = [
        ValueTextModel(selected: true, value: 0)
      ];
      List<int> selectedItems = [];
      for (int i = 0; i < trLocationLimitModel.locationsList.length; i++) {
        if (trLocationLimitModel.locationsList[i].selected!) {
          selectedItems.add(trLocationLimitModel.locationsList[i].value!);
        }
      }
      var request = {
        "id": 0,
        "limit": trLocationLimitModel.limit.value,
        "expireDate": trLocationLimitModel.selectedDatePost.value,
        "locationIdArr": selectedItems.join(','),
        "districtId": ApiFilters.getDistrictId()
      };
      var expectedResponse = {
        "message": "Location limit edited successfully",
        "id": null
      };

      when(() => mockHTTPClient.editLocationLimit(request))
          .thenAnswer((invocation) async {
        return http.Response('''$expectedResponse''', 200);
      });
      final response = await mockHTTPClient.editLocationLimit(request);
      expect(response.statusCode, 200);
    });

    test('add or edit Location limit when location is not selected', () async {
      trLocationLimitModel.limit.value = 0;
      trLocationLimitModel.selectedDatePost.value = '0';
      trLocationLimitModel.locationsList = [
        ValueTextModel(selected: false, value: 0)
      ];
      await trLocationLimitModel.validations();
      expect(trLocationLimitModel.locationStatusError.value, true);
    });

    test('add or edit Location limit when limit is not selected', () async {
      trLocationLimitModel.limit.text = '';
      trLocationLimitModel.selectedDatePost.value = '00/00/0000';
      trLocationLimitModel.locationsList = [
        ValueTextModel(selected: true, value: 0)
      ];
      await trLocationLimitModel.validations();
      expect(trLocationLimitModel.limitError.value, true);
    });
    test('add or edit Location limit when date is not selected', () async {
      trLocationLimitModel.limit.text = 'limit';
      trLocationLimitModel.selectedDatePost.value = '';
      trLocationLimitModel.locationsList = [
        ValueTextModel(selected: true, value: 0)
      ];
      await trLocationLimitModel.validations();
      expect(trLocationLimitModel.dateError.value, true);
    });
  });
}
