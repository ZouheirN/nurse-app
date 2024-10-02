class NursesModel {
  List<Nurse>? nurses;

  NursesModel({
    this.nurses,
  });

  factory NursesModel.fromJson(Map<String, dynamic> json) => NursesModel(
    nurses: json["nurses"] == null ? [] : List<Nurse>.from(json["nurses"]!.map((x) => Nurse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "nurses": nurses == null ? [] : List<dynamic>.from(nurses!.map((x) => x.toJson())),
  };
}

class Nurse {
  num? id;
  String? name;
  String? phoneNumber;
  String? address;
  String? profilePicture;
  String? gender;
  DateTime? createdAt;
  DateTime? updatedAt;

  Nurse({
    this.id,
    this.name,
    this.phoneNumber,
    this.address,
    this.profilePicture,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
    id: json["id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    profilePicture: json["profile_picture"],
    gender: json["gender"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone_number": phoneNumber,
    "address": address,
    "profile_picture": profilePicture,
    "gender": gender,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
