class GetServicesFromAreaModel {
  GetServicesFromAreaModel({
    required this.area,
    required this.services,
  });

  final Area? area;
  final List<Service> services;

  GetServicesFromAreaModel copyWith({
    Area? area,
    List<Service>? services,
  }) {
    return GetServicesFromAreaModel(
      area: area ?? this.area,
      services: services ?? this.services,
    );
  }

  factory GetServicesFromAreaModel.fromJson(Map<String, dynamic> json){
    return GetServicesFromAreaModel(
      area: json["area"] == null ? null : Area.fromJson(json["area"]),
      services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "area": area?.toJson(),
    "services": services.map((x) => x?.toJson()).toList(),
  };

}

class Area {
  Area({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  Area copyWith({
    int? id,
    String? name,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Area.fromJson(Map<String, dynamic> json){
    return Area(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
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
    required this.category,
    required this.areaName,
    required this.hasAreaPricing,
    required this.translation,
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
  final Area? category;
  final String? areaName;
  final bool? hasAreaPricing;
  final Translation? translation;
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
    Area? category,
    String? areaName,
    bool? hasAreaPricing,
    Translation? translation,
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
      category: category ?? this.category,
      areaName: areaName ?? this.areaName,
      hasAreaPricing: hasAreaPricing ?? this.hasAreaPricing,
      translation: translation ?? this.translation,
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
      category: json["category"] == null ? null : Area.fromJson(json["category"]),
      areaName: json["area_name"],
      hasAreaPricing: json["has_area_pricing"],
      translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
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
    "category": category?.toJson(),
    "area_name": areaName,
    "has_area_pricing": hasAreaPricing,
    "translation": translation?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}

class Translation {
  Translation({
    required this.locale,
    required this.name,
  });

  final String? locale;
  final String? name;

  Translation copyWith({
    String? locale,
    String? name,
  }) {
    return Translation(
      locale: locale ?? this.locale,
      name: name ?? this.name,
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json){
    return Translation(
      locale: json["locale"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "locale": locale,
    "name": name,
  };

}
