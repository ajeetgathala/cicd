class LocationLimitsModel {
  int? id;
  String? expireDate;
  int? passLimitId;
  String? passLimitValue;
  int? districtId;
  String? districtName;
  String? status;
  String? creator;
  String? locationIdArr;
  String? locationNameArr;
  String? schoolIdArr;
  String? schoolNameArr;

  LocationLimitsModel(
      {this.id,
      this.expireDate,
      this.passLimitId,
      this.passLimitValue,
      this.districtId,
      this.districtName,
      this.status,
      this.creator,
      this.locationIdArr,
      this.locationNameArr,
      this.schoolIdArr,
      this.schoolNameArr});

  LocationLimitsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expireDate = json['expireDate'];
    passLimitId = json['passLimitId'];
    passLimitValue = json['passLimitValue'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    status = json['status'];
    creator = json['creator'];
    locationIdArr = json['locationIdArr'];
    locationNameArr = json['locationNameArr'];
    schoolIdArr = json['schoolIdArr'];
    schoolNameArr = json['schoolNameArr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expireDate'] = expireDate;
    data['passLimitId'] = passLimitId;
    data['passLimitValue'] = passLimitValue;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['status'] = status;
    data['creator'] = creator;
    data['locationIdArr'] = locationIdArr;
    data['locationNameArr'] = locationNameArr;
    data['schoolIdArr'] = schoolIdArr;
    data['schoolNameArr'] = schoolNameArr;
    return data;
  }
}
