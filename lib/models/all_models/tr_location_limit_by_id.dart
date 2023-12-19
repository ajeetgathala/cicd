class TrLocationLimitById {
  int? id;
  int? passLimitId;
  String? passLimit;
  String? startDate;
  String? endDate;
  String? reason;
  int? repetitionId;
  int? districtId;
  String? districtName;
  int? status;
  String? studentIdArr;

  TrLocationLimitById(
      {this.id,
      this.passLimitId,
      this.passLimit,
      this.startDate,
      this.endDate,
      this.reason,
      this.repetitionId,
      this.districtId,
      this.districtName,
      this.status,
      this.studentIdArr});

  TrLocationLimitById.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    passLimitId = json['passLimitId'];
    passLimit = json['passLimit'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    reason = json['reason'];
    repetitionId = json['repetitionId'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    status = json['status'];
    studentIdArr = json['studentIdArr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['passLimitId'] = passLimitId;
    data['passLimit'] = passLimit;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['reason'] = reason;
    data['repetitionId'] = repetitionId;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['status'] = status;
    data['studentIdArr'] = studentIdArr;
    return data;
  }
}
