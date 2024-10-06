class RequestsHistoryModel {
  num? id;
  num? userId;
  String? fullName;
  String? phoneNumber;
  num? nurseId;
  String? status;
  DateTime? scheduledTime;
  DateTime? endingTime;
  String? location;
  String? nurseGender;
  String? problemDescription;
  String? timeType;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  User? user;
  Nurse? nurse;
  List<Service>? services;
  num? timeNeededToArrive;

  RequestsHistoryModel({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.nurseId,
    this.status,
    this.scheduledTime,
    this.endingTime,
    this.location,
    this.nurseGender,
    this.problemDescription,
    this.timeType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
    this.nurse,
    this.services,
    this.timeNeededToArrive,
  });

  factory RequestsHistoryModel.fromJson(Map<String, dynamic> json) =>
      RequestsHistoryModel(
        id: json["id"],
        userId: json["user_id"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        nurseId: json["nurse_id"],
        status: json["status"],
        scheduledTime: json["scheduled_time"] == null
            ? null
            : DateTime.parse(json["scheduled_time"]),
        endingTime: json["ending_time"] == null
            ? null
            : DateTime.parse(json["ending_time"]),
        location: json["location"],
        nurseGender: json["nurse_gender"],
        problemDescription: json["problem_description"],
        timeType: json["time_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        nurse: json["nurse"] == null ? null : Nurse.fromJson(json["nurse"]),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        timeNeededToArrive: json["time_needed_to_arrive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "nurse_id": nurseId,
        "status": status,
        "scheduled_time": scheduledTime?.toIso8601String(),
        "ending_time": endingTime?.toIso8601String(),
        "location": location,
        "nurse_gender": nurseGender,
        "problem_description": problemDescription,
        "time_type": timeType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
        "user": user?.toJson(),
        "nurse": nurse?.toJson(),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "time_needed_to_arrive": timeNeededToArrive,
      };
}

class Nurse {
  num? id;
  String? name;
  String? phoneNumber;
  String? profilePicture;
  String? gender;

  Nurse({
    this.id,
    this.name,
    this.phoneNumber,
    this.profilePicture,
    this.gender,
  });

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        profilePicture: json["profile_picture"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "profile_picture": profilePicture,
        "gender": gender,
      };
}

class Service {
  num? id;
  String? name;
  String? description;
  String? servicePic;
  String? price;
  String? discountPrice;
  num? categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  Service({
    this.id,
    this.name,
    this.description,
    this.servicePic,
    this.price,
    this.discountPrice,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        servicePic: json["service_pic"],
        price: json["price"],
        discountPrice: json["discount_price"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "service_pic": servicePic,
        "price": price,
        "discount_price": discountPrice,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class Pivot {
  num? requestId;
  num? serviceId;

  Pivot({
    this.requestId,
    this.serviceId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        requestId: json["request_id"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "service_id": serviceId,
      };
}

class User {
  num? id;
  num? roleId;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  String? phoneNumber;
  String? location;
  num? latitude;
  num? longitude;
  DateTime? confirmationCodeExpiresAt;
  bool? isFirstLogin;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phoneNumber,
    this.location,
    this.latitude,
    this.longitude,
    this.confirmationCodeExpiresAt,
    this.isFirstLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        roleId: json["role_id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        phoneNumber: json["phone_number"],
        location: json["location"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        confirmationCodeExpiresAt: json["confirmation_code_expires_at"] == null
            ? null
            : DateTime.parse(json["confirmation_code_expires_at"]),
        isFirstLogin: json["is_first_login"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "phone_number": phoneNumber,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "confirmation_code_expires_at":
            confirmationCodeExpiresAt?.toIso8601String(),
        "is_first_login": isFirstLogin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
