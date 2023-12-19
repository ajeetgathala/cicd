class ErrorsModel {
  String? type;
  String? title;
  int? status;
  String? detail;
  String? traceId;

  ErrorsModel({this.type, this.title, this.status, this.detail, this.traceId});

  ErrorsModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    status = json['status'];
    detail = json['detail'];
    traceId = json['traceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['status'] = status;
    data['detail'] = detail;
    data['traceId'] = traceId;
    return data;
  }
}
