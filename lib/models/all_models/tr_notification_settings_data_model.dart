class TrNotificationSettingsDataModel {
  int? id;
  bool? allNotifications;
  bool? newPassNotifications;
  bool? reminders;
  bool? alerts;
  bool? completed;
  bool? departed;

  TrNotificationSettingsDataModel(
      {this.id,
      this.allNotifications,
      this.newPassNotifications,
      this.reminders,
      this.alerts,
      this.completed,
      this.departed});

  TrNotificationSettingsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    allNotifications = json['allNotifications'];
    newPassNotifications = json['newPassNotifications'];
    reminders = json['reminders'];
    alerts = json['alerts'];
    completed = json['completed'];
    departed = json['departed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['allNotifications'] = allNotifications;
    data['newPassNotifications'] = newPassNotifications;
    data['reminders'] = reminders;
    data['alerts'] = alerts;
    data['completed'] = completed;
    data['departed'] = departed;
    return data;
  }
}
