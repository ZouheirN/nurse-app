class GetPopupsAdminModel {
  GetPopupsAdminModel({
    required this.popups,
  });

  final List<Popup> popups;

  GetPopupsAdminModel copyWith({
    List<Popup>? popups,
  }) {
    return GetPopupsAdminModel(
      popups: popups ?? this.popups,
    );
  }

  factory GetPopupsAdminModel.fromJson(Map<String, dynamic> json){
    return GetPopupsAdminModel(
      popups: json["popups"] == null ? [] : List<Popup>.from(json["popups"]!.map((x) => Popup.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "popups": popups.map((x) => x?.toJson()).toList(),
  };

}

class Popup {
  Popup({
    required this.id,
    required this.image,
    required this.title,
    required this.content,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? image;
  final String? title;
  final String? content;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Popup copyWith({
    int? id,
    String? image,
    String? title,
    String? content,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Popup(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Popup.fromJson(Map<String, dynamic> json){
    return Popup(
      id: json["id"],
      image: json["image"],
      title: json["title"],
      content: json["content"],
      type: json["type"],
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      endDate: DateTime.tryParse(json["end_date"] ?? ""),
      isActive: json["is_active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "content": content,
    "type": type,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
