abstract class BaseApiServices {
  Future<dynamic> getApi(String api);

  Future<dynamic> postApi(dynamic data, String api);

  Future<dynamic> putApi(dynamic data, String api);

  Future<dynamic> postMultipartApi(String api, int id, file);
}
