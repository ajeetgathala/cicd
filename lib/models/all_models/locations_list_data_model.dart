class LocationsListDataModel {
  int? id;
  String? image;
  String? locationName;
  int? limitId;
  String? limit;
  String? timeId;
  String? time;
  String? notificationBufferTimeId;
  String? notificationBufferTime;
  String? ePassExpiredTimeId;
  String? ePassExpiredTime;
  String? status;
  int? districtId;
  String? districtName;
  String? schoolId;
  String? schoolName;
  bool? search;
  bool? select;

  LocationsListDataModel(
      {this.id,
      this.image,
      this.locationName,
      this.limitId,
      this.limit,
      this.timeId,
      this.time,
      this.notificationBufferTimeId,
      this.notificationBufferTime,
      this.ePassExpiredTimeId,
      this.ePassExpiredTime,
      this.status,
      this.districtId,
      this.districtName,
      this.schoolId,
      this.schoolName,
      this.search = true,
      this.select = false});

  LocationsListDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    locationName = json['locationName'];
    limitId = json['limitId'];
    limit = json['limit'];
    timeId = json['timeId'];
    time = json['time'];
    notificationBufferTimeId = json['notificationBufferTimeId'];
    notificationBufferTime = json['notificationBufferTime'];
    ePassExpiredTimeId = json['ePassExpiredTimeId'];
    ePassExpiredTime = json['ePassExpiredTime'];
    status = json['status'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
    search = true;
    select = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['locationName'] = locationName;
    data['limitId'] = limitId;
    data['limit'] = limit;
    data['timeId'] = timeId;
    data['time'] = time;
    data['notificationBufferTimeId'] = notificationBufferTimeId;
    data['notificationBufferTime'] = notificationBufferTime;
    data['ePassExpiredTimeId'] = ePassExpiredTimeId;
    data['ePassExpiredTime'] = ePassExpiredTime;
    data['status'] = status;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    return data;
  }
}
