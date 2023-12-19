class DistrictDataModel {
  int? id;
  String? name;
  int? stateId;
  String? stateName;
  int? countryId;
  String? countryName;
  String? description;
  String? numberOfTimesToRemind;
  String? delayBetweenReminder;
  String? phone;
  String? status;
  bool search = true;

  DistrictDataModel(
      {this.id,
      this.name,
      this.stateId,
      this.stateName,
      this.countryId,
      this.countryName,
      this.description,
      this.numberOfTimesToRemind,
      this.delayBetweenReminder,
      this.phone,
      this.status,
      this.search = true});

  DistrictDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    countryId = json['countryId'];
    countryName = json['countryName'];
    description = json['description'];
    numberOfTimesToRemind = json['numberOfTimesToRemind'];
    delayBetweenReminder = json['delayBetweenReminder'];
    phone = json['phone'];
    status = json['status'];
    search = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    data['description'] = description;
    data['numberOfTimesToRemind'] = numberOfTimesToRemind;
    data['delayBetweenReminder'] = delayBetweenReminder;
    data['phone'] = phone;
    data['status'] = status;
    return data;
  }
}
