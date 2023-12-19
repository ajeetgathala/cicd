class SchoolsDataModel {
  int? id;
  String? schoolCode;
  String? schoolName;
  String? schoolDistrict;
  String? state;
  String? phoneNumber;
  String? status;
  bool search = true;

  SchoolsDataModel(
      {this.id,
      this.schoolCode,
      this.schoolName,
      this.schoolDistrict,
      this.state,
      this.phoneNumber,
      this.status,
      this.search = true});

  SchoolsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolCode = json['schoolCode'];
    schoolName = json['schoolName'];
    schoolDistrict = json['schoolDistrict'];
    state = json['state'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    search = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['schoolCode'] = schoolCode;
    data['schoolName'] = schoolName;
    data['schoolDistrict'] = schoolDistrict;
    data['state'] = state;
    data['phoneNumber'] = phoneNumber;
    data['status'] = status;
    return data;
  }
}
