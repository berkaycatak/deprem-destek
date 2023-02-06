class AfetzedeLocationListModel {
  int? id;
  double? lat;
  double? lng;
  String? description;
  String? nameSurname;
  String? phoneNumber;
  int? who;
  String? updatedAt;
  String? createdAt;

  AfetzedeLocationListModel(
      {this.id,
      this.lat,
      this.lng,
      this.description,
      this.nameSurname,
      this.phoneNumber,
      this.who,
      this.updatedAt,
      this.createdAt});

  AfetzedeLocationListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    lng = json['lng'];
    description = json['description'];
    nameSurname = json['name_surname'];
    phoneNumber = json['phone_number'];
    who = json['who'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['lng'] = lng;
    data['description'] = description;
    data['name_surname'] = nameSurname;
    data['phone_number'] = phoneNumber;
    data['who'] = who;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
