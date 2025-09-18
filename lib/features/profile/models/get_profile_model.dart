class GetProfileModel {
  GetProfileModel({
    required this.id,
    required this.roleId,
    required this.areaId,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.emailVerifiedAt,
    required this.phoneNumber,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.confirmationCode,
    required this.confirmationCodeExpiresAt,
    required this.isFirstLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? roleId;
  final dynamic areaId;
  final String? name;
  final String? email;
  final String? birthDate;
  final DateTime? emailVerifiedAt;
  final String? phoneNumber;
  final String? location;
  final num? latitude;
  final num? longitude;
  final dynamic confirmationCode;
  final dynamic confirmationCodeExpiresAt;
  final bool? isFirstLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GetProfileModel copyWith({
    int? id,
    int? roleId,
    dynamic areaId,
    String? name,
    String? email,
    String? birthDate,
    DateTime? emailVerifiedAt,
    String? phoneNumber,
    String? location,
    num? latitude,
    num? longitude,
    dynamic confirmationCode,
    dynamic confirmationCodeExpiresAt,
    bool? isFirstLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GetProfileModel(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      areaId: areaId ?? this.areaId,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      confirmationCodeExpiresAt: confirmationCodeExpiresAt ?? this.confirmationCodeExpiresAt,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory GetProfileModel.fromJson(Map<String, dynamic> json){
    return GetProfileModel(
      id: json["id"],
      roleId: json["role_id"],
      areaId: json["area_id"],
      name: json["name"],
      email: json["email"],
      birthDate: json["birth_date"] ?? "",
      emailVerifiedAt: DateTime.tryParse(json["email_verified_at"] ?? ""),
      phoneNumber: json["phone_number"],
      location: json["location"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      confirmationCode: json["confirmation_code"],
      confirmationCodeExpiresAt: json["confirmation_code_expires_at"],
      isFirstLogin: json["is_first_login"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "area_id": areaId,
    "name": name,
    "email": email,
    "birth_date": birthDate,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "phone_number": phoneNumber,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "confirmation_code": confirmationCode,
    "confirmation_code_expires_at": confirmationCodeExpiresAt,
    "is_first_login": isFirstLogin,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
