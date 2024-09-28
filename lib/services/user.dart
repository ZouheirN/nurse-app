import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';

class UserBox {
  static final _box = Hive.box('userBox');

  static void saveUser(UserModel user) {
    _box.put('user', user);
  }

  static void setUserLocation({
    required double latitude,
    required double longitude,
    required String location,
  }) {
    final user = _box.get('user') as UserModel;
    user.latitude = latitude;
    user.longitude = longitude;
    user.location = location;
    _box.put('user', user);
  }

  static ValueListenable<Box> listenToUser() {
    return _box.listenable(keys: ['user']);
  }

  static UserModel? getUser() {
    return _box.get('user');
  }

  static void deleteUser() {
    _box.delete('user');
  }

  static bool isUserLoggedIn() {
    return _box.get('user') != null;
  }
}
