class DashboardDataModel {
  String? todayOutOfOffice;
  int? locationLimit;
  int? limitStudentPasses;
  int? contactControl;
  int? outOfOffice;
  int? receivedPass;
  int? raisedPass;
  int? approvedPass;
  int? completedPass;
  int? rejectedPass;
  int? departedPass;
  int? alertPass;
  int? totalPass;
  int? preventedConstraints;
  int? overriddenConstraints;

  DashboardDataModel(
      {this.todayOutOfOffice,
      this.locationLimit,
      this.limitStudentPasses,
      this.contactControl,
      this.outOfOffice,
      this.receivedPass,
      this.raisedPass,
      this.approvedPass,
      this.completedPass,
      this.rejectedPass,
      this.departedPass,
      this.alertPass,
      this.totalPass,
      this.preventedConstraints,
      this.overriddenConstraints});

  DashboardDataModel.fromJson(Map<String, dynamic> json) {
    todayOutOfOffice = json['todayOutOfOffice'];
    locationLimit = json['locationLimit'];
    limitStudentPasses = json['limitStudentPasses'];
    contactControl = json['contactControl'];
    outOfOffice = json['outOfOffice'];
    receivedPass = json['receivedPass'];
    raisedPass = json['raisedPass'];
    approvedPass = json['approvedPass'];
    completedPass = json['completedPass'];
    rejectedPass = json['rejectedPass'];
    departedPass = json['departedPass'];
    alertPass = json['alertPass'];
    totalPass = json['totalPass'];
    preventedConstraints = json['preventedConstraints'];
    overriddenConstraints = json['overriddenConstraints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['todayOutOfOffice'] = todayOutOfOffice;
    data['locationLimit'] = locationLimit;
    data['limitStudentPasses'] = limitStudentPasses;
    data['contactControl'] = contactControl;
    data['outOfOffice'] = outOfOffice;
    data['receivedPass'] = receivedPass;
    data['raisedPass'] = raisedPass;
    data['approvedPass'] = approvedPass;
    data['completedPass'] = completedPass;
    data['rejectedPass'] = rejectedPass;
    data['departedPass'] = departedPass;
    data['alertPass'] = alertPass;
    data['totalPass'] = totalPass;
    data['preventedConstraints'] = preventedConstraints;
    data['overriddenConstraints'] = overriddenConstraints;
    return data;
  }
}
