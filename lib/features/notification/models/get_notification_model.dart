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
    required this.type,
    required this.data,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final String type;
  final Data? data;
  final DateTime? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Notification copyWith({
    int? id,
    int? userId,
    String? type,
    Data? data,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json){
    return Notification(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      type: json["type"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      readAt: DateTime.tryParse(json["read_at"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "data": data?.toJson(),
    "read_at": readAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}

class Data {
  Data({
    required this.requestId,
    required this.status,
  });

  final int requestId;
  final String status;

  Data copyWith({
    int? requestId,
    String? status,
  }) {
    return Data(
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      requestId: json["request_id"] ?? 0,
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "status": status,
  };

}
