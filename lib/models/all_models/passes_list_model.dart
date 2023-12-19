class PassesListModel {
  int? id;
  int? departingLocationId;
  String? departingLocationName;
  String? departingLocationImage;
  int? departingTeacherId;
  String? departingTeacherName;
  String? departingTeacherImage;
  int? destinationLocationId;
  String? destinationLocationName;
  String? destinationLocationImage;
  int? destinationTeacherId;
  String? destinationTeacherName;
  String? destinationTeacherImage;
  String? issueTime;
  String? outTime;
  String? inTime;
  String? diffTime;
  String? comment;
  int? status;
  String? statusText;
  int? districtId;
  String? schoolId;
  String? locationId;
  int? studentId;
  String? studentName;
  int? creatorId;
  String? creatorName;
  int? journeyTimeId;
  String? journeyTime;
  int? ePassTimeId;
  String? ePassTime;
  String? departedBy;
  String? departedTime;
  String? receivedTime;
  String? approvedTime;
  int? todayCount;
  String? validationType;
  String? validationText;

  PassesListModel(
      {this.id,
      this.departingLocationId,
      this.departingLocationName,
      this.departingLocationImage,
      this.departingTeacherId,
      this.departingTeacherName,
      this.departingTeacherImage,
      this.destinationLocationId,
      this.destinationLocationName,
      this.destinationLocationImage,
      this.destinationTeacherId,
      this.destinationTeacherName,
      this.destinationTeacherImage,
      this.issueTime,
      this.outTime,
      this.inTime,
      this.diffTime,
      this.comment,
      this.status,
      this.statusText,
      this.districtId,
      this.schoolId,
      this.locationId,
      this.studentId,
      this.studentName,
      this.creatorId,
      this.creatorName,
      this.journeyTimeId,
      this.journeyTime,
      this.ePassTimeId,
      this.ePassTime,
      this.departedBy,
      this.departedTime,
      this.receivedTime,
      this.approvedTime,
      this.todayCount,
      this.validationType,
      this.validationText});

  PassesListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departingLocationId = json['departingLocationId'];
    departingLocationName = json['departingLocationName'];
    departingLocationImage = json['departingLocationImage'];
    departingTeacherId = json['departingTeacherId'];
    departingTeacherName = json['departingTeacherName'];
    departingTeacherImage = json['departingTeacherImage'];
    destinationLocationId = json['destinationLocationId'];
    destinationLocationName = json['destinationLocationName'];
    destinationLocationImage = json['destinationLocationImage'];
    destinationTeacherId = json['destinationTeacherId'];
    destinationTeacherName = json['destinationTeacherName'];
    destinationTeacherImage = json['destinationTeacherImage'];
    issueTime = json['issueTime'];
    outTime = json['outTime'];
    inTime = json['inTime'];
    diffTime = json['diffTime'];
    comment = json['comment'];
    status = json['status'];
    statusText = json['statusText'];
    districtId = json['districtId'];
    schoolId = json['schoolId'];
    locationId = json['locationId'];
    studentId = json['studentId'];
    studentName = json['studentName'];
    creatorId = json['creatorId'];
    creatorName = json['creatorName'];
    journeyTimeId = json['journeyTimeId'];
    journeyTime = json['journeyTime'];
    ePassTimeId = json['ePassTimeId'];
    ePassTime = json['ePassTime'];
    departedBy = json['departedBy'];
    departedTime = json['departedTime'];
    receivedTime = json['receivedTime'];
    approvedTime = json['approvedTime'];
    todayCount = json['todayCount'];
    validationType = json['validationType'];
    validationText = json['validationText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['departingLocationId'] = departingLocationId;
    data['departingLocationName'] = departingLocationName;
    data['departingLocationImage'] = departingLocationImage;
    data['departingTeacherId'] = departingTeacherId;
    data['departingTeacherName'] = departingTeacherName;
    data['departingTeacherImage'] = departingTeacherImage;
    data['destinationLocationId'] = destinationLocationId;
    data['destinationLocationName'] = destinationLocationName;
    data['destinationLocationImage'] = destinationLocationImage;
    data['destinationTeacherId'] = destinationTeacherId;
    data['destinationTeacherName'] = destinationTeacherName;
    data['destinationTeacherImage'] = destinationTeacherImage;
    data['issueTime'] = issueTime;
    data['outTime'] = outTime;
    data['inTime'] = inTime;
    data['diffTime'] = diffTime;
    data['comment'] = comment;
    data['status'] = status;
    data['statusText'] = statusText;
    data['districtId'] = districtId;
    data['schoolId'] = schoolId;
    data['locationId'] = locationId;
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['creatorId'] = creatorId;
    data['creatorName'] = creatorName;
    data['journeyTimeId'] = journeyTimeId;
    data['journeyTime'] = journeyTime;
    data['ePassTimeId'] = ePassTimeId;
    data['ePassTime'] = ePassTime;
    data['departedBy'] = departedBy;
    data['departedTime'] = departedTime;
    data['receivedTime'] = receivedTime;
    data['approvedTime'] = approvedTime;
    data['todayCount'] = todayCount;
    data['validationType'] = validationType;
    data['validationText'] = validationText;
    return data;
  }
}
