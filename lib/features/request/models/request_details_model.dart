class RequestDetailsModel {
  RequestDetailsModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.problemDescription,
    required this.status,
    required this.nurseGender,
    required this.timeType,
    required this.scheduledTime,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.timeNeededToArrive,
    required this.createdAt,
    required this.updatedAt,
    required this.services,
    required this.user,
  });

  final int id;
  final int userId;
  final String fullName;
  final String phoneNumber;
  final String problemDescription;
  final String status;
  final String nurseGender;
  final String timeType;
  final DateTime? scheduledTime;
  final String location;
  final num latitude;
  final num longitude;
  final num timeNeededToArrive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Service> services;
  final User? user;

  RequestDetailsModel copyWith({
    int? id,
    int? userId,
    String? fullName,
    String? phoneNumber,
    String? problemDescription,
    String? status,
    String? nurseGender,
    String? timeType,
    DateTime? scheduledTime,
    String? location,
    num? latitude,
    num? longitude,
    num? timeNeededToArrive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Service>? services,
    User? user,
  }) {
    return RequestDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      problemDescription: problemDescription ?? this.problemDescription,
      status: status ?? this.status,
      nurseGender: nurseGender ?? this.nurseGender,
      timeType: timeType ?? this.timeType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timeNeededToArrive: timeNeededToArrive ?? this.timeNeededToArrive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      services: services ?? this.services,
      user: user ?? this.user,
    );
  }

  factory RequestDetailsModel.fromJson(Map<String, dynamic> json){
    return RequestDetailsModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      fullName: json["full_name"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      problemDescription: json["problem_description"] ?? "",
      status: json["status"] ?? "",
      nurseGender: json["nurse_gender"] ?? "",
      timeType: json["time_type"] ?? "",
      scheduledTime: DateTime.tryParse(json["scheduled_time"] ?? ""),
      location: json["location"] ?? "",
      latitude: json["latitude"] ?? 0,
      longitude: json["longitude"] ?? 0,
      timeNeededToArrive: json["time_needed_to_arrive"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "problem_description": problemDescription,
    "status": status,
    "nurse_gender": nurseGender,
    "time_type": timeType,
    "scheduled_time": scheduledTime?.toIso8601String(),
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "time_needed_to_arrive": timeNeededToArrive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "services": services.map((x) => x?.toJson()).toList(),
    "user": user?.toJson(),
  };

}

class Service {
  Service({
    required this.id,
    required this.name,
    required this.price,
  });

  final int id;
  final String name;
  final String price;

  Service copyWith({
    int? id,
    String? name,
    String? price,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: json["price"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
  };

}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };

}
