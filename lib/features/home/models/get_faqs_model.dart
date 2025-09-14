class GetFaqsModel {
  GetFaqsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<Datum> data;

  GetFaqsModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) {
    return GetFaqsModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory GetFaqsModel.fromJson(Map<String, dynamic> json){
    return GetFaqsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
    required this.isActive,
    required this.translation,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? question;
  final String? answer;
  final num? order;
  final bool? isActive;
  final Translation? translation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum copyWith({
    int? id,
    String? question,
    String? answer,
    num? order,
    bool? isActive,
    Translation? translation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Datum(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      translation: translation ?? this.translation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
      order: json["order"],
      isActive: json["is_active"],
      translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "order": order,
    "is_active": isActive,
    "translation": translation?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}

class Translation {
  Translation({
    required this.locale,
    required this.question,
    required this.answer,
  });

  final String? locale;
  final String? question;
  final String? answer;

  Translation copyWith({
    String? locale,
    String? question,
    String? answer,
  }) {
    return Translation(
      locale: locale ?? this.locale,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json){
    return Translation(
      locale: json["locale"],
      question: json["question"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() => {
    "locale": locale,
    "question": question,
    "answer": answer,
  };

}
