class TrOutOfOfficeDataModelList {
  int? id;
  String? title;
  int? presets;
  String? startDate;
  String? startTime;
  String? endTime;
  String? repetition;
  String? reason;
  String? status;
  int? creator;
  String? creationDate;
  int? modifier;
  String? modifyDate;
  int? teacherId;
  String? teacherName;
  int? districtId;
  String? districtName;
  String? schoolId;
  String? schoolName;

  TrOutOfOfficeDataModelList(
      {this.id,
      this.title,
      this.presets,
      this.startDate,
      this.startTime,
      this.endTime,
      this.repetition,
      this.reason,
      this.status,
      this.creator,
      this.creationDate,
      this.modifier,
      this.modifyDate,
      this.teacherId,
      this.teacherName,
      this.districtId,
      this.districtName,
      this.schoolId,
      this.schoolName});

  TrOutOfOfficeDataModelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    presets = json['presets'];
    startDate = json['startDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    repetition = json['repetition'];
    reason = json['reason'];
    status = json['status'];
    creator = json['creator'];
    creationDate = json['creationDate'];
    modifier = json['modifier'];
    modifyDate = json['modifyDate'];
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['presets'] = presets;
    data['startDate'] = startDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['repetition'] = repetition;
    data['reason'] = reason;
    data['status'] = status;
    data['creator'] = creator;
    data['creationDate'] = creationDate;
    data['modifier'] = modifier;
    data['modifyDate'] = modifyDate;
    data['teacherId'] = teacherId;
    data['teacherName'] = teacherName;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    return data;
  }
}
