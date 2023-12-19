class LoginResponse {
  int? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? jwtToken;
  int? userTypeId;
  String? userType;
  int? privilegeFirst;
  int? privilegeSecond;
  int? privilegeThird;
  int? permission;

  LoginResponse(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.jwtToken,
      this.userTypeId,
      this.userType,
      this.privilegeFirst,
      this.privilegeSecond,
      this.privilegeThird,
      this.permission});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    jwtToken = json['jwtToken'];
    userTypeId = json['userTypeId'];
    userType = json['userType'];
    privilegeFirst = json['privilegeFirst'];
    privilegeSecond = json['privilegeSecond'];
    privilegeThird = json['privilegeThird'];
    permission = json['permission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['jwtToken'] = jwtToken;
    data['userTypeId'] = userTypeId;
    data['userType'] = userType;
    data['privilegeFirst'] = privilegeFirst;
    data['privilegeSecond'] = privilegeSecond;
    data['privilegeThird'] = privilegeThird;
    data['permission'] = permission;
    return data;
  }
}
