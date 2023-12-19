class StPassLimitDataModel {
  int? passLimit;
  int? passUsed;

  StPassLimitDataModel({this.passLimit, this.passUsed});

  StPassLimitDataModel.fromJson(Map<String, dynamic> json) {
    passLimit = json['passLimit'];
    passUsed = json['passUsed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passLimit'] = passLimit;
    data['passUsed'] = passUsed;
    return data;
  }
}
