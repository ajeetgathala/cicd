class ProfileDataModel {
  int? id;
  String? employeeId;
  String? studentIdNumber;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? imagePath;
  String? phone;
  String? comments;
  int? userTypeId;
  int? permissionGroupId;
  int? status;
  int? districtId;
  String? ePassMaxTime;
  int? privilegeFirst;
  int? privilegeSecond;
  int? privilegeThird;
  int? permission;
  String? schoolIdArr;

  ProfileDataModel(
      {this.id,
      this.employeeId,
      this.studentIdNumber,
      this.firstName,
      this.lastName,
      this.userName,
      this.email,
      this.imagePath,
      this.phone,
      this.comments,
      this.userTypeId,
      this.permissionGroupId,
      this.status,
      this.districtId,
      this.ePassMaxTime,
      this.privilegeFirst,
      this.privilegeSecond,
      this.privilegeThird,
      this.permission,
      this.schoolIdArr});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    studentIdNumber = json['studentIdNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    email = json['email'];
    imagePath = json['imagePath'];
    phone = json['phone'];
    comments = json['comments'];
    userTypeId = json['userTypeId'];
    permissionGroupId = json['permissionGroupId'];
    status = json['status'];
    districtId = json['districtId'];
    ePassMaxTime = json['ePassMaxTime'];
    privilegeFirst = json['privilegeFirst'];
    privilegeSecond = json['privilegeSecond'];
    privilegeThird = json['privilegeThird'];
    permission = json['permission'];
    schoolIdArr = json['schoolIdArr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['studentIdNumber'] = studentIdNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['email'] = email;
    data['imagePath'] = imagePath;
    data['phone'] = phone;
    data['comments'] = comments;
    data['userTypeId'] = userTypeId;
    data['permissionGroupId'] = permissionGroupId;
    data['status'] = status;
    data['districtId'] = districtId;
    data['ePassMaxTime'] = ePassMaxTime;
    data['privilegeFirst'] = privilegeFirst;
    data['privilegeSecond'] = privilegeSecond;
    data['privilegeThird'] = privilegeThird;
    data['permission'] = permission;
    data['schoolIdArr'] = schoolIdArr;
    return data;
  }
}
