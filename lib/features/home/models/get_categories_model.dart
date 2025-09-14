class GetCategoriesModel {
  GetCategoriesModel({
    required this.categories,
  });

  final List<Category> categories;

  GetCategoriesModel copyWith({
    List<Category>? categories,
  }) {
    return GetCategoriesModel(
      categories: categories ?? this.categories,
    );
  }

  factory GetCategoriesModel.fromJson(Map<String, dynamic> json){
    return GetCategoriesModel(
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "categories": categories.map((x) => x.toJson()).toList(),
  };

}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category copyWith({
    int? id,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["id"],
      name: json["name"],
      imageUrl: json["image_url"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
