class TrLimitStudentPassesModel {
  int? id;
  int? districtId;
  String? districtName;
  String? startDate;
  String? endDate;
  int? passLimitId;
  String? passLimitValue;
  int? repetitionId;
  String? repetition;
  String? reason;
  String? status;
  String? schoolId;
  String? schoolName;
  String? studentIdArr;
  String? studentNameArr;
  String? comments;

  TrLimitStudentPassesModel(
      {this.id,
      this.districtId,
      this.districtName,
      this.startDate,
      this.endDate,
      this.passLimitId,
      this.passLimitValue,
      this.repetitionId,
      this.repetition,
      this.reason,
      this.status,
      this.schoolId,
      this.schoolName,
      this.studentIdArr,
      this.studentNameArr,
      this.comments});

  TrLimitStudentPassesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    passLimitId = json['passLimitId'];
    passLimitValue = json['passLimitValue'];
    repetitionId = json['repetitionId'];
    repetition = json['repetition'];
    reason = json['reason'];
    status = json['status'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
    studentIdArr = json['studentIdArr'];
    studentNameArr = json['studentNameArr'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['passLimitId'] = passLimitId;
    data['passLimitValue'] = passLimitValue;
    data['repetitionId'] = repetitionId;
    data['repetition'] = repetition;
    data['reason'] = reason;
    data['status'] = status;
    data['schoolId'] = schoolId;
    data['schoolName'] = schoolName;
    data['studentIdArr'] = studentIdArr;
    data['studentNameArr'] = studentNameArr;
    data['comments'] = comments;
    return data;
  }
}
