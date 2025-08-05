class GetContactFormsModel {
  GetContactFormsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
  });

  final bool? success;
  final String? message;
  final List<Datum> data;
  final num? totalCount;

  GetContactFormsModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
    num? totalCount,
  }) {
    return GetContactFormsModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  factory GetContactFormsModel.fromJson(Map<String, dynamic> json){
    return GetContactFormsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      totalCount: json["total_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
    "total_count": totalCount,
  };

}

class Datum {
  Datum({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.fullName,
    required this.address,
    required this.description,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? firstName;
  final String? secondName;
  final String? fullName;
  final String? address;
  final String? description;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum copyWith({
    int? id,
    String? firstName,
    String? secondName,
    String? fullName,
    String? address,
    String? description,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Datum(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      firstName: json["first_name"],
      secondName: json["second_name"],
      fullName: json["full_name"],
      address: json["address"],
      description: json["description"],
      phoneNumber: json["phone_number"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "second_name": secondName,
    "full_name": fullName,
    "address": address,
    "description": description,
    "phone_number": phoneNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
