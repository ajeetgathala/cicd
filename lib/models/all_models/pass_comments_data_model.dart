class PassCommentsDataModel {
  int? id;
  String? comment;
  String? creator;
  String? creationDate;

  PassCommentsDataModel(
      {this.id, this.comment, this.creator, this.creationDate});

  PassCommentsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    creator = json['creator'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['creator'] = creator;
    data['creationDate'] = creationDate;
    return data;
  }
}
