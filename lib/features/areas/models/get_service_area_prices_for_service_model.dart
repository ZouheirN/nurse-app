class GetServiceAreaPricesForService {
  GetServiceAreaPricesForService({
    required this.service,
    required this.areaPrices,
  });

  final Service? service;
  final List<AreaPrice> areaPrices;

  GetServiceAreaPricesForService copyWith({
    Service? service,
    List<AreaPrice>? areaPrices,
  }) {
    return GetServiceAreaPricesForService(
      service: service ?? this.service,
      areaPrices: areaPrices ?? this.areaPrices,
    );
  }

  factory GetServiceAreaPricesForService.fromJson(Map<String, dynamic> json){
    return GetServiceAreaPricesForService(
      service: json["service"] == null ? null : Service.fromJson(json["service"]),
      areaPrices: json["area_prices"] == null ? [] : List<AreaPrice>.from(json["area_prices"]!.map((x) => AreaPrice.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "service": service?.toJson(),
    "area_prices": areaPrices.map((x) => x.toJson()).toList(),
  };

}

class AreaPrice {
  AreaPrice({
    required this.id,
    required this.areaId,
    required this.price,
    required this.area,
  });

  final int? id;
  final int? areaId;
  final String? price;
  final Area? area;

  AreaPrice copyWith({
    int? id,
    int? areaId,
    String? price,
    Area? area,
  }) {
    return AreaPrice(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      price: price ?? this.price,
      area: area ?? this.area,
    );
  }

  factory AreaPrice.fromJson(Map<String, dynamic> json){
    return AreaPrice(
      id: json["id"],
      areaId: json["area_id"],
      price: json["price"],
      area: json["area"] == null ? null : Area.fromJson(json["area"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "area_id": areaId,
    "price": price,
    "area": area?.toJson(),
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
  Service({required this.json});
  final Map<String,dynamic> json;

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
        json: json
    );
  }

  Map<String, dynamic> toJson() => {
  };

}
