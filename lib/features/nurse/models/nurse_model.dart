class NurseModel {
  Nurse? nurse;
  dynamic averageRating;

  NurseModel({
    this.nurse,
    this.averageRating,
  });

  factory NurseModel.fromJson(Map<String, dynamic> json) => NurseModel(
    nurse: json["nurse"] == null ? null : Nurse.fromJson(json["nurse"]),
    averageRating: json["average_rating"],
  );

  Map<String, dynamic> toJson() => {
    "nurse": nurse?.toJson(),
    "average_rating": averageRating,
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
  List<dynamic>? ratings;

  Nurse({
    this.id,
    this.name,
    this.phoneNumber,
    this.address,
    this.profilePicture,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.ratings,
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
    ratings: json["ratings"] == null ? [] : List<dynamic>.from(json["ratings"]!.map((x) => x)),
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
    "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x)),
  };
}
