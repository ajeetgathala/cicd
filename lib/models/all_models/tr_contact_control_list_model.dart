class ContactControlListModel {
  int? id;
  String? expireDate;
  String? expireTime;
  String? adminOnlyNote;
  int? timesTriggered;
  String? status;
  int? districtId;
  String? districtName;
  String? schoolId;
  String? schoolName;
  String? studentId;
  String? studentName;
  String? locationId;
  String? locationName;
  String? creator;
  String? creationDate;
  String? modifier;
  String? modifyDate;

  ContactControlListModel(
      {this.id,
      this.expireDate,
      this.expireTime,
      this.adminOnlyNote,
      this.timesTriggered,
      this.status,
      this.districtId,
      this.districtName,
      this.schoolId,
      this.schoolName,
      this.studentId,
      this.studentName,
      this.locationId,
      this.locationName,
      this.creator,
      this.creationDate,
      this.modifier,
      this.modifyDate});

  ContactControlListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expireDate = json['expireDate'];
    expireTime = json['expireTime'];
    adminOnlyNote = json['adminOnlyNote'];
    timesTriggered = json['timesTriggered'];
    status = json['status'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
    studentId = json['studentId'];
    studentName = json['studentName'];
    locationId = json['locationId'];
    locationName = json['locationName'];
    creator = json['creator'];
    creationDate = json['creationDate'];
    modifier = json['modifier'];
    modifyDate = json['modifyDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expireDate'] = expireDate;
    data['expireTime'] = expireTime;
    data['adminOnlyNote'] = adminOnlyNote;
    data['timesTriggered'] = timesTriggered;
    data['status'] = status;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['locationId'] = locationId;
    data['locationName'] = locationName;
    data['creator'] = creator;
    data['creationDate'] = creationDate;
    data['modifier'] = modifier;
    data['modifyDate'] = modifyDate;
    return data;
  }
}
