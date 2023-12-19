import 'dart:async';

import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/data/api/api_filters.dart';
import 'package:cicd/data/api/apis.dart';
import 'package:cicd/data/network/network_api_services.dart';
import 'package:cicd/models/common_models/message_model.dart';
import 'package:http/http.dart';

class Repositories {
  final _apiService = NetworkApiServices(Client());

  Future<dynamic> tokenRefreshApi() async {
    dynamic response = await _apiService.postApi({}, Apis.refreshToken);
    MessageModel tokenModel = MessageModel.fromJson(response);
    AppSharedPreferences.putString(
        AppSharedPreferences.token, tokenModel.message!);
    return response;
  }

  Future<dynamic> loginApi(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.logIn);
    return response;
  }

  Future<dynamic> postFcmToken(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.postFcmToken);
    return response;
  }

  Future<dynamic> sendOtp(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.otpRequest);
    return response;
  }

  Future<dynamic> verifyOtp(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.otpVerify);
    return response;
  }

  Future<dynamic> sendOtpForPassword(var data) async {
    dynamic response =
        await _apiService.postApi(data, Apis.forgotPasswordOtpRequest);
    return response;
  }

  Future<dynamic> resetPassword(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.resetPassword);
    return response;
  }

  Future<dynamic> getDropDownLimits() async {
    dynamic response = await _apiService.getApi(Apis.dropDownLimit);
    return response;
  }

  Future<dynamic> getLocationLimits() async {
    dynamic response = await _apiService
        .getApi('${Apis.locationLimits}${ApiFilters.getSchoolFilter()}');
    return response;
  }

  Future<dynamic> addLocationLimit(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.locationLimits);
    return response;
  }

  Future<dynamic> editLocationLimit(var data) async {
    dynamic response = await _apiService.putApi(data, Apis.locationLimits);
    return response;
  }

  Future<dynamic> getLocationLimitById(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.locationLimitById}?id=$id');
    return response;
  }

  Future<dynamic> getContactControlList() async {
    dynamic response = await _apiService.getApi(
        '${Apis.contactControl}${ApiFilters.getSchoolDistrictFilter()}');
    return response;
  }

  Future<dynamic> getContactControlById(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.contactControlById}?id=$id');
    return response;
  }

  Future<dynamic> getStudentsListDropDown() async {
    dynamic response = await _apiService.getApi(
        "${Apis.getStudentsDropListData}${ApiFilters.getSchoolFilter()}");
    return response;
  }

  Future<dynamic> addContactControl(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.contactControl);
    return response;
  }

  Future<dynamic> editContactControl(var data) async {
    dynamic response = await _apiService.putApi(data, Apis.contactControl);
    return response;
  }

  Future<dynamic> addOutOfOffice(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.outOfOffice);
    return response;
  }

  Future<dynamic> editOutOfOffice(var data) async {
    dynamic response = await _apiService.putApi(data, Apis.outOfOffice);
    return response;
  }

  Future<dynamic> getPresetsListDropDown() async {
    dynamic response = await _apiService.getApi(Apis.getPresetsDropListData);
    return response;
  }

  Future<dynamic> getTimeData() async {
    dynamic response = await _apiService.getApi(Apis.getTimeData);
    return response;
  }

  Future<dynamic> getRepetitionListDropDown() async {
    dynamic response = await _apiService.getApi(Apis.getRepetitionDropListData);
    return response;
  }

  Future<dynamic> getLimitStudentPasses() async {
    dynamic response = await _apiService
        .getApi('${Apis.studentLimitPasses}${ApiFilters.getDistrictFilter()}');
    return response;
  }

  Future<dynamic> getLimitStudentPasseById(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.getStudentLimitPassesById}?id=$id');
    return response;
  }

  Future<dynamic> addLimitStudentPasses(var data) async {
    dynamic response = await _apiService.postApi(data, Apis.studentLimitPasses);
    return response;
  }

  Future<dynamic> editLimitStudentPasses(var data) async {
    dynamic response = await _apiService.putApi(data, Apis.studentLimitPasses);
    return response;
  }

  Future<dynamic> getTeacherLocationsDropDown() async {
    dynamic response =
        await _apiService.getApi('${Apis.getTeacherLocationsDropDown}'
            '${ApiFilters.getSchoolDistrictFilter()}');
    return response;
  }

  Future<dynamic> getOnlyLocations() async {
    dynamic response = await _apiService.getApi('${Apis.getOnlyLocations}'
        '${ApiFilters.getSchoolDistrictFilter()}');
    return response;
  }

  Future<dynamic> getLocations() async {
    dynamic response = await _apiService.getApi('${Apis.getLocations}'
        '${ApiFilters.getDistrictFilter()}');
    return response;
  }

  Future<dynamic> getEPassStatus() async {
    dynamic response = await _apiService.getApi(Apis.getEPassStatus);
    return response;
  }

  Future<dynamic> getStPassLimit() async {
    dynamic response = await _apiService
        .getApi('${Apis.getStudentEPassLimit}${ApiFilters.getStudentFilter()}');
    return response;
  }

  Future<dynamic> getTeacherDropDown() async {
    dynamic response = await _apiService.getApi(Apis.getTeacherDropDown);
    return response;
  }

  Future<dynamic> addNewPass(data) async {
    dynamic response = await _apiService.postApi(data, Apis.addNewPass);
    return response;
  }

  Future<dynamic> requestNewPass(data) async {
    dynamic response = await _apiService.postApi(data, Apis.requestNewPass);
    return response;
  }

  Future<dynamic> getPassById(id) async {
    dynamic response = await _apiService.getApi('${Apis.getPassById}?Id=$id');
    return response;
  }

  Future<dynamic> getPasses() async {
    dynamic response = await _apiService
        .getApi('${Apis.getAllPasses}${ApiFilters.getEPassListFilter()}');
    return response;
  }

  Future<dynamic> getStudentPasses() async {
    dynamic response = await _apiService
        .getApi('${Apis.getStAllPasses}${ApiFilters.getStudentFilter()}');
    return response;
  }

  Future<dynamic> getOutOfOfficeList() async {
    dynamic response = await _apiService
        .getApi('${Apis.outOfOffice}${ApiFilters.getSchoolFilter()}');
    return response;
  }

  Future<dynamic> getOutOfOfficeById(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.outOfOfficeById}?id=$id');
    return response;
  }

  Future<dynamic> postComment(data) async {
    dynamic response = await _apiService.postApi(data, Apis.postComment);
    return response;
  }

  Future<dynamic> postApproval(data) async {
    dynamic response =
        await _apiService.postApi({}, '${Apis.postApproval}$data');
    return response;
  }

  Future<dynamic> postDeparted(data) async {
    dynamic response =
        await _apiService.postApi({}, '${Apis.postDeparted}$data');
    return response;
  }

  Future<dynamic> postRejection(data) async {
    dynamic response =
        await _apiService.postApi({}, '${Apis.postRejection}$data');
    return response;
  }

  Future<dynamic> postEnd(data) async {
    dynamic response = await _apiService.postApi({}, '${Apis.postEnd}$data');
    return response;
  }

  Future<dynamic> postReceived(data) async {
    dynamic response =
        await _apiService.postApi({}, '${Apis.postReceived}$data');
    return response;
  }

  Future<dynamic> getProfile(id) async {
    dynamic response = await _apiService.getApi('${Apis.getProfile}?id=$id');
    return response;
  }

  Future<dynamic> updateProfile(id, file) async {
    dynamic response =
        await _apiService.postMultipartApi(Apis.updateProfileImage, id, file);
    return response;
  }

  Future<dynamic> getLogout() async {
    dynamic response = await _apiService.getApi(Apis.getLogout);
    return response;
  }

  Future<dynamic> getDistricts() async {
    dynamic response = await _apiService
        .getApi('${Apis.getDistricts}${ApiFilters.appendUserID('')}');
    return response;
  }

  Future<dynamic> getLimits() async {
    dynamic response = await _apiService.getApi(Apis.getLimits);
    return response;
  }

  Future<dynamic> getSchools() async {
    dynamic response = await _apiService
        .getApi('${Apis.getSchools}${ApiFilters.getDistrictFilter()}');
    return response;
  }

  Future<dynamic> getDashboardData() async {
    dynamic response = await _apiService.getApi(
        '${Apis.getDashboardData}${ApiFilters.getSchoolDistrictUserFilter()}');
    return response;
  }

  Future<dynamic> postResume() async {
    dynamic response = await _apiService.postApi({},
        '${Apis.postResume}?teacherId=${await AppSharedPreferences.getInt(AppSharedPreferences.id)}');
    return response;
  }

  Future<dynamic> getCommentsList(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.getPassComments}?ePassId=$id');
    return response;
  }

  Future<dynamic> getNotifications(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.getNotifications}?userId=$id');
    return response;
  }

  Future<dynamic> getAlerts(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.getAlerts}?ePassId=$id');
    return response;
  }

  Future<dynamic> getNotificationSettings(id) async {
    dynamic response =
        await _apiService.getApi('${Apis.getNotificationSettings}?userid=$id');
    return response;
  }

  Future<dynamic> postNotificationSetting(data) async {
    dynamic response =
        await _apiService.postApi(data, Apis.postNotificationSettings);
    return response;
  }
}
