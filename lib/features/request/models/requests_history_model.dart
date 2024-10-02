class RequestsHistoryModel {
  num? id;
  num? userId;
  String? fullName;
  String? phoneNumber;
  num? nurseId;
  String? status;
  num? timeNeededToArrive;
  DateTime? scheduledTime;
  DateTime? endingTime;
  String? location;
  String? nurseGender;
  String? problemDescription;
  String? timeType;
  DateTime? createdAt;
  DateTime? updatedAt;
  Nurse? nurse;
  List<Service>? services;

  RequestsHistoryModel({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.nurseId,
    this.status,
    this.timeNeededToArrive,
    this.scheduledTime,
    this.endingTime,
    this.location,
    this.nurseGender,
    this.problemDescription,
    this.timeType,
    this.createdAt,
    this.updatedAt,
    this.nurse,
    this.services,
  });

  factory RequestsHistoryModel.fromJson(Map<String, dynamic> json) => RequestsHistoryModel(
    id: json["id"],
    userId: json["user_id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    nurseId: json["nurse_id"],
    status: json["status"],
    timeNeededToArrive: json["time_needed_to_arrive"],
    scheduledTime: json["scheduled_time"] == null ? null : DateTime.parse(json["scheduled_time"]),
    endingTime: json["ending_time"] == null ? null : DateTime.parse(json["ending_time"]),
    location: json["location"],
    nurseGender: json["nurse_gender"],
    problemDescription: json["problem_description"],
    timeType: json["time_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    nurse: json['nurse'] == null ? null : Nurse.fromJson(json["nurse"]),
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "nurse_id": nurseId,
    "status": status,
    "time_needed_to_arrive": timeNeededToArrive,
    "scheduled_time": scheduledTime?.toIso8601String(),
    "ending_time": endingTime?.toIso8601String(),
    "location": location,
    "nurse_gender": nurseGender,
    "problem_description": problemDescription,
    "time_type": timeType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "nurse": nurse?.toJson(),
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
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
  String? servicePic;
  String? price;
  String? discountPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  Pivot? pivot;

  Service({
    this.id,
    this.name,
    this.servicePic,
    this.price,
    this.discountPrice,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    servicePic: json["service_pic"],
    price: json["price"],
    discountPrice: json["discount_price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "service_pic": servicePic,
    "price": price,
    "discount_price": discountPrice,
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
