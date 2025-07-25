class GetNotificationsModel {
  GetNotificationsModel({
    required this.notifications,
  });

  final List<Notification> notifications;

  GetNotificationsModel copyWith({
    List<Notification>? notifications,
  }) {
    return GetNotificationsModel(
      notifications: notifications ?? this.notifications,
    );
  }

  factory GetNotificationsModel.fromJson(Map<String, dynamic> json){
    return GetNotificationsModel(
      notifications: json["notifications"] == null ? [] : List<Notification>.from(json["notifications"]!.map((x) => Notification.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "notifications": notifications.map((x) => x?.toJson()).toList(),
  };

}

class Notification {
  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? userId;
  final String? message;
  final String? type;
  final dynamic readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Notification copyWith({
    int? id,
    int? userId,
    String? message,
    String? type,
    dynamic? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      type: type ?? this.type,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json){
    return Notification(
      id: json["id"],
      userId: json["user_id"],
      message: json["message"],
      type: json["type"],
      readAt: json["read_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "message": message,
    "type": type,
    "read_at": readAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}
