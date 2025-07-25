class GetSlidersModel {
  GetSlidersModel({
    required this.sliders,
  });

  final List<Slider> sliders;

  GetSlidersModel copyWith({
    List<Slider>? sliders,
  }) {
    return GetSlidersModel(
      sliders: sliders ?? this.sliders,
    );
  }

  factory GetSlidersModel.fromJson(Map<String, dynamic> json){
    return GetSlidersModel(
      sliders: json["sliders"] == null ? [] : List<Slider>.from(json["sliders"]!.map((x) => Slider.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "sliders": sliders.map((x) => x.toJson()).toList(),
  };

}

class Slider {
  Slider({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.position,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? image;
  final String? title;
  final String? subtitle;
  final num? position;
  final String? link;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Slider copyWith({
    int? id,
    String? image,
    String? title,
    String? subtitle,
    num? position,
    String? link,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Slider(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      position: position ?? this.position,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Slider.fromJson(Map<String, dynamic> json){
    return Slider(
      id: json["id"],
      image: json["image"],
      title: json["title"],
      subtitle: json["subtitle"],
      position: json["position"],
      link: json["link"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "subtitle": subtitle,
    "position": position,
    "link": link,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
