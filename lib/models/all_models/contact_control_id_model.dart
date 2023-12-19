class ContactControlIdModel {
  int? id;
  String? adminOnlyNote;
  String? expireDate;
  String? expireTime;
  int? creator;
  String? creationDate;
  String? studentId;
  String? locationId;
  int? status;
  String? modifyDate;

  ContactControlIdModel(
      {this.id,
      this.adminOnlyNote,
      this.expireDate,
      this.expireTime,
      this.creator,
      this.creationDate,
      this.studentId,
      this.locationId,
      this.status,
      this.modifyDate});

  ContactControlIdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminOnlyNote = json['adminOnlyNote'];
    expireDate = json['expireDate'];
    expireTime = json['expireTime'];
    creator = json['creator'];
    creationDate = json['creationDate'];
    studentId = json['studentId'];
    locationId = json['locationId'];
    status = json['status'];
    modifyDate = json['modifyDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['adminOnlyNote'] = adminOnlyNote;
    data['expireDate'] = expireDate;
    data['expireTime'] = expireTime;
    data['creator'] = creator;
    data['creationDate'] = creationDate;
    data['studentId'] = studentId;
    data['locationId'] = locationId;
    data['status'] = status;
    data['modifyDate'] = modifyDate;
    return data;
  }
}
