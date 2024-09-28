import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final num? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? phoneNumber;
  @HiveField(4)
  final String? location;
  @HiveField(5)
  final num? roleId;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.location,
    this.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      location: json['location'],
      roleId: json['role_id'],
    );
  }
}