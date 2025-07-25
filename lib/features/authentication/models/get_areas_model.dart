class GetAreasModel {
  GetAreasModel({
    required this.areas,
  });

  final List<Area> areas;

  GetAreasModel copyWith({
    List<Area>? areas,
  }) {
    return GetAreasModel(
      areas: areas ?? this.areas,
    );
  }

  factory GetAreasModel.fromJson(Map<String, dynamic> json){
    return GetAreasModel(
      areas: json["areas"] == null ? [] : List<Area>.from(json["areas"]!.map((x) => Area.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "areas": areas.map((x) => x?.toJson()).toList(),
  };

}

class Area {
  Area({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Area copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Area.fromJson(Map<String, dynamic> json){
    return Area(
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
