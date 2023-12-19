class TrLocationLimitDataModel {
  int? id;
  int? limitId;
  String? limit;
  String? expireDate;
  int? status;
  int? districtId;
  String? districtName;
  String? locationIdArr;

  TrLocationLimitDataModel(
      {this.id,
      this.limitId,
      this.limit,
      this.expireDate,
      this.status,
      this.districtId,
      this.districtName,
      this.locationIdArr});

  TrLocationLimitDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    limitId = json['limitId'];
    limit = json['limit'];
    expireDate = json['expireDate'];
    status = json['status'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    locationIdArr = json['locationIdArr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['limitId'] = limitId;
    data['limit'] = limit;
    data['expireDate'] = expireDate;
    data['status'] = status;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['locationIdArr'] = locationIdArr;
    return data;
  }
}
