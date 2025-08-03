class GetCustomNotificationsModel {
  GetCustomNotificationsModel({
    required this.notifications,
  });

  final List<Notification> notifications;

  GetCustomNotificationsModel copyWith({
    List<Notification>? notifications,
  }) {
    return GetCustomNotificationsModel(
      notifications: notifications ?? this.notifications,
    );
  }

  factory GetCustomNotificationsModel.fromJson(Map<String, dynamic> json){
    return GetCustomNotificationsModel(
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
    required this.title,
    required this.message,
    required this.type,
    required this.sentByAdminId,
    required this.readAt,
    required this.createdAt,
    required this.user,
  });

  final int? id;
  final int? userId;
  final String? title;
  final String? message;
  final String? type;
  final int? sentByAdminId;
  final DateTime? readAt;
  final DateTime? createdAt;
  final User? user;

  Notification copyWith({
    int? id,
    int? userId,
    String? title,
    String? message,
    String? type,
    int? sentByAdminId,
    DateTime? readAt,
    DateTime? createdAt,
    User? user,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      sentByAdminId: sentByAdminId ?? this.sentByAdminId,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json){
    return Notification(
      id: json["id"],
      userId: json["user_id"],
      title: json["title"],
      message: json["message"],
      type: json["type"],
      sentByAdminId: json["sent_by_admin_id"],
      readAt: DateTime.tryParse(json["read_at"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "message": message,
    "type": type,
    "sent_by_admin_id": sentByAdminId,
    "read_at": readAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "user": user?.toJson(),
  };

}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  final int? id;
  final String? name;
  final String? email;

  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };

}
