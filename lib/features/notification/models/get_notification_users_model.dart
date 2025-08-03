class GetNotificationUsersModel {
  GetNotificationUsersModel({
    required this.users,
  });

  final List<User> users;

  GetNotificationUsersModel copyWith({
    List<User>? users,
  }) {
    return GetNotificationUsersModel(
      users: users ?? this.users,
    );
  }

  factory GetNotificationUsersModel.fromJson(Map<String, dynamic> json){
    return GetNotificationUsersModel(
      users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "users": users.map((x) => x?.toJson()).toList(),
  };

}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  final int? id;
  final String? name;
  final String? email;
  final DateTime? createdAt;

  User copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "created_at": createdAt?.toIso8601String(),
  };

}
