class GetAreasAdminModel {
  GetAreasAdminModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<Datum> data;

  GetAreasAdminModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) {
    return GetAreasAdminModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory GetAreasAdminModel.fromJson(Map<String, dynamic> json){
    return GetAreasAdminModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.usersCount,
    required this.servicePricesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final num? usersCount;
  final num? servicePricesCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum copyWith({
    int? id,
    String? name,
    num? usersCount,
    num? servicePricesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Datum(
      id: id ?? this.id,
      name: name ?? this.name,
      usersCount: usersCount ?? this.usersCount,
      servicePricesCount: servicePricesCount ?? this.servicePricesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      name: json["name"],
      usersCount: json["users_count"],
      servicePricesCount: json["service_prices_count"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "users_count": usersCount,
    "service_prices_count": servicePricesCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
