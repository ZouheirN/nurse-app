import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  num? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phoneNumber;
  @HiveField(4)
  String? location;
  @HiveField(5)
  num? roleId;
  @HiveField(6)
  num? latitude;
  @HiveField(7)
  num? longitude;
  @HiveField(8)
  String? birthDate;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.location,
    this.roleId,
    this.latitude,
    this.longitude,
    this.birthDate
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      location: json['location'],
      roleId: json['role_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      birthDate: json['birth_date'],
    );
  }
}