class ValueTextModel {
  int? value;
  String? type;
  String? text;
  bool? selected;
  bool? search;
  String? ePassExpiredTime;

  ValueTextModel(
      {this.value,
      this.type,
      this.text,
      this.selected,
      this.search,
      this.ePassExpiredTime});

  ValueTextModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
    text = json['text'];
    selected = false;
    search = true;
    ePassExpiredTime = json['ePassExpiredTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['type'] = type;
    data['text'] = text;
    data['ePassExpiredTime'] = ePassExpiredTime;
    return data;
  }
}
