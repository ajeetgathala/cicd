class TrNotificationsDataModel {
  int? id;
  String? entryDate;
  bool? isSend;
  int? userId;
  String? registrationToken;
  String? typeName;
  int? typeId;
  String? title;
  String? message;

  TrNotificationsDataModel(
      {this.id,
      this.entryDate,
      this.isSend,
      this.userId,
      this.registrationToken,
      this.typeName,
      this.typeId,
      this.title,
      this.message});

  TrNotificationsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entryDate = json['entryDate'];
    isSend = json['isSend'];
    userId = json['userId'];
    registrationToken = json['registrationToken'];
    typeName = json['typeName'];
    typeId = json['typeId'];
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['entryDate'] = entryDate;
    data['isSend'] = isSend;
    data['userId'] = userId;
    data['registrationToken'] = registrationToken;
    data['typeName'] = typeName;
    data['typeId'] = typeId;
    data['title'] = title;
    data['message'] = message;
    return data;
  }
}
