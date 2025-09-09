class RequestsHistoryModel {
  RequestsHistoryModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.name,
    required this.problemDescription,
    required this.status,
    required this.timeNeededToArrive,
    required this.nurseGender,
    required this.timeType,
    required this.scheduledTime,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.totalPrice,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.services,
  });

  final int? id;
  final int? userId;
  final String? fullName;
  final String? phoneNumber;
  final String? name;
  final String? problemDescription;
  final String? status;
  final num? timeNeededToArrive;
  final String? nurseGender;
  final String? timeType;
  final DateTime? scheduledTime;
  final String? location;
  final num? latitude;
  final num? longitude;
  final num? totalPrice;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final List<Service> services;

  RequestsHistoryModel copyWith({
    int? id,
    int? userId,
    String? fullName,
    String? phoneNumber,
    String? name,
    String? problemDescription,
    String? status,
    num? timeNeededToArrive,
    String? nurseGender,
    String? timeType,
    DateTime? scheduledTime,
    String? location,
    num? latitude,
    num? longitude,
    num? totalPrice,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    List<Service>? services,
  }) {
    return RequestsHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      problemDescription: problemDescription ?? this.problemDescription,
      status: status ?? this.status,
      timeNeededToArrive: timeNeededToArrive ?? this.timeNeededToArrive,
      nurseGender: nurseGender ?? this.nurseGender,
      timeType: timeType ?? this.timeType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalPrice: totalPrice ?? this.totalPrice,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      services: services ?? this.services,
    );
  }

  factory RequestsHistoryModel.fromJson(Map<String, dynamic> json) {
    return RequestsHistoryModel(
      id: json["id"],
      userId: json["user_id"],
      fullName: json["full_name"],
      phoneNumber: json["phone_number"],
      name: json["name"],
      problemDescription: json["problem_description"],
      status: json["status"],
      timeNeededToArrive: json["time_needed_to_arrive"],
      nurseGender: json["nurse_gender"],
      timeType: json["time_type"],
      scheduledTime: DateTime.tryParse(json["scheduled_time"] ?? ""),
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      totalPrice: json["total_price"],
      deletedAt: DateTime.tryParse(json["deleted_at"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      services: json["services"] == null
          ? []
          : List<Service>.from(
              json["services"]!.map((x) => Service.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "name": name,
        "problem_description": problemDescription,
        "status": status,
        "time_needed_to_arrive": timeNeededToArrive,
        "nurse_gender": nurseGender,
        "time_type": timeType,
        "scheduled_time": scheduledTime?.toIso8601String(),
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "total_price": totalPrice,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "services": services.map((x) => x?.toJson()).toList(),
      };
}

class Service {
  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.servicePic,
    required this.price,
    required this.discountPrice,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? servicePic;
  final String? price;
  final String? discountPrice;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pivot? pivot;

  Service copyWith({
    int? id,
    String? name,
    String? description,
    String? servicePic,
    String? price,
    String? discountPrice,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Pivot? pivot,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      servicePic: servicePic ?? this.servicePic,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pivot: pivot ?? this.pivot,
    );
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      servicePic: json["service_pic"],
      price: json["price"],
      discountPrice: json["discount_price"],
      categoryId: json["category_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );
  }

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
  Pivot({
    required this.requestId,
    required this.serviceId,
  });

  final int? requestId;
  final int? serviceId;

  Pivot copyWith({
    int? requestId,
    int? serviceId,
  }) {
    return Pivot(
      requestId: requestId ?? this.requestId,
      serviceId: serviceId ?? this.serviceId,
    );
  }

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      requestId: json["request_id"],
      serviceId: json["service_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "service_id": serviceId,
      };
}

class User {
  User({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.phoneNumber,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.confirmationCodeExpiresAt,
    required this.isFirstLogin,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  final int? id;
  final int? roleId;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? phoneNumber;
  final String? location;
  final num? latitude;
  final num? longitude;
  final dynamic confirmationCodeExpiresAt;
  final bool? isFirstLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Role? role;

  User copyWith({
    int? id,
    int? roleId,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? phoneNumber,
    String? location,
    num? latitude,
    num? longitude,
    dynamic? confirmationCodeExpiresAt,
    bool? isFirstLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
    Role? role,
  }) {
    return User(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      confirmationCodeExpiresAt:
          confirmationCodeExpiresAt ?? this.confirmationCodeExpiresAt,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      roleId: json["role_id"],
      name: json["name"],
      email: json["email"],
      emailVerifiedAt: DateTime.tryParse(json["email_verified_at"] ?? ""),
      phoneNumber: json["phone_number"],
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      confirmationCodeExpiresAt: json["confirmation_code_expires_at"],
      isFirstLogin: json["is_first_login"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      role: json["role"] == null ? null : Role.fromJson(json["role"]),
    );
  }

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
        "confirmation_code_expires_at": confirmationCodeExpiresAt,
        "is_first_login": isFirstLogin,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "role": role?.toJson(),
      };
}

class Role {
  Role({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Role copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
