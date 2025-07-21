class GetServicesModel {
  GetServicesModel({
    required this.services,
  });

  final List<Service> services;

  GetServicesModel copyWith({
    List<Service>? services,
  }) {
    return GetServicesModel(
      services: services ?? this.services,
    );
  }

  factory GetServicesModel.fromJson(Map<String, dynamic> json){
    return GetServicesModel(
      services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "services": services.map((x) => x.toJson()).toList(),
  };

}

class Service {
  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.servicePic,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final String? discountPrice;
  final String? servicePic;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Service copyWith({
    int? id,
    String? name,
    String? description,
    String? price,
    String? discountPrice,
    String? servicePic,
    int? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      servicePic: servicePic ?? this.servicePic,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
      discountPrice: json["discount_price"],
      servicePic: json["service_pic"],
      categoryId: json["category_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "discount_price": discountPrice,
    "service_pic": servicePic,
    "category_id": categoryId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
