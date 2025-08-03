class GetServiceAreaPricesModel {
  GetServiceAreaPricesModel({
    required this.serviceAreaPrices,
  });

  final List<ServiceAreaPrice> serviceAreaPrices;

  GetServiceAreaPricesModel copyWith({
    List<ServiceAreaPrice>? serviceAreaPrices,
  }) {
    return GetServiceAreaPricesModel(
      serviceAreaPrices: serviceAreaPrices ?? this.serviceAreaPrices,
    );
  }

  factory GetServiceAreaPricesModel.fromJson(Map<String, dynamic> json){
    return GetServiceAreaPricesModel(
      serviceAreaPrices: json["service_area_prices"] == null ? [] : List<ServiceAreaPrice>.from(json["service_area_prices"]!.map((x) => ServiceAreaPrice.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "service_area_prices": serviceAreaPrices.map((x) => x?.toJson()).toList(),
  };

}

class ServiceAreaPrice {
  ServiceAreaPrice({
    required this.id,
    required this.serviceId,
    required this.areaId,
    required this.price,
    required this.service,
    required this.area,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? serviceId;
  final int? areaId;
  final num? price;
  final Area? service;
  final Area? area;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceAreaPrice copyWith({
    int? id,
    int? serviceId,
    int? areaId,
    num? price,
    Area? service,
    Area? area,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceAreaPrice(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      areaId: areaId ?? this.areaId,
      price: price ?? this.price,
      service: service ?? this.service,
      area: area ?? this.area,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ServiceAreaPrice.fromJson(Map<String, dynamic> json){
    return ServiceAreaPrice(
      id: json["id"],
      serviceId: json["service_id"],
      areaId: json["area_id"],
      price: json["price"],
      service: json["service"] == null ? null : Area.fromJson(json["service"]),
      area: json["area"] == null ? null : Area.fromJson(json["area"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "area_id": areaId,
    "price": price,
    "service": service?.toJson(),
    "area": area?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
