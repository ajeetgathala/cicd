import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cicd/constants/app_shared_preferences.dart';
import 'package:cicd/constants/app_strings.dart';
import 'package:cicd/data/api/apis.dart';
import 'package:cicd/constants/app_exceptions.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/models/common_models/errors_model.dart';
import 'package:cicd/models/common_models/message_model.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final utils = getIt<Utils>();

  bool tokenError = false;

  final http.Client client;

  NetworkApiServices(this.client);

  String applicationJson = "application/json";
  String accept = "Accept";
  String contentType = "content-type";
  String authorization = 'Authorization';
  String bearer = 'Bearer';

  @override
  Future<dynamic> getApi(String api) async {
    Utils.print(api);
    dynamic responseJson;
    var header = await getHeader(0);
    try {
      final response = await client
          .get(Uri.parse(api), headers: header)
          .timeout(const Duration(seconds: 30));
      Utils.print(response.body);
      responseJson = returnResponse(response, api);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String api) async {
    Utils.print(api);
    Utils.print(data);

    dynamic responseJson;
    var header = await getHeader(0);

    try {
      final response = await client
          .post(Uri.parse(api), headers: header, body: jsonEncode(data))
          .timeout(const Duration(seconds: 100));
      Utils.print(response.body);

      responseJson = returnResponse(response, api);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> putApi(var data, String api) async {
    Utils.print(api);
    Utils.print(data);

    dynamic responseJson;
    var header = await getHeader(0);
    try {
      final response = await client
          .put(Uri.parse(api), headers: header, body: jsonEncode(data))
          .timeout(const Duration(seconds: 100));
      Utils.print(response.body);

      responseJson = returnResponse(response, api);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postMultipartApi(String api, int id, file) async {
    Utils.print(api);
    Utils.print(id);
    Utils.print(file.path);
    dynamic responseJson;
    try {
      Uri uri = Uri.parse(api);

      var headers = await getHeader(1);

      if (file.path != '') {
        var request = http.MultipartRequest('POST', uri)
          ..fields["Id"] = id.toString();

        String fileName = file.path.split("/").last;
        var stream = http.ByteStream(file.openRead());
        stream.cast();
        var length = await file.length();
        var multipartFileSign =
            http.MultipartFile('Image', stream, length, filename: fileName);
        request.files.add(multipartFileSign);

        request.headers.addAll(headers);

        var response = await http.Response.fromStream(await request.send());
        Utils.print(response);

        responseJson = returnResponse(response, api);
      } else {
        throw InvalidUrlException('File can not be null');
      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response, api) async {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
        if (api == Apis.refreshToken) {
          await AppSharedPreferences.clearPreferences();
          Get.offAllNamed(Routes.login);
          try {
            MessageModel errorsModel =
                MessageModel.fromJson(jsonDecode(response.body));
            utils.snackBarMessage(AppStrings.error, errorsModel.message!);
          } on NullException {
            Utils.print(AppStrings.nullDataFound);
            throw NullException();
          }
          throw InvalidUrlException(response.body);
        } else {
          throw InvalidUrlException(Utils.e401);
        }
      case 403:
        if ([Apis.refreshToken, Apis.getProfile].contains(api)) {
          await AppSharedPreferences.clearPreferences();
          Get.offAllNamed(Routes.login);
        }
        throw InvalidUrlException(response.body);

      default:
        bool shown = false;
        try {
          MessageModel errorsModel =
              MessageModel.fromJson(jsonDecode(response.body));
          utils.snackBarMessage(AppStrings.error, errorsModel.message!);
          shown = true;
        } catch (e) {
          Utils.print(e.toString());
        }
        try {
          if (!shown) {
            ErrorsModel errorsModel =
                ErrorsModel.fromJson(jsonDecode(response.body));
            utils.snackBarMessage(AppStrings.error, errorsModel.title!);
          }
        } catch (e) {
          Utils.print(e.toString());
        }
        throw FetchDataException(response.body);
    }
  }

  Future<Map<String, String>> getHeader(int type) async {
    return {
      if (type != 1) accept: applicationJson,
      if (type != 1) contentType: applicationJson,
      authorization:
          '$bearer ${await AppSharedPreferences.getString(AppSharedPreferences.token)}'
    };
  }
}
