import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../consts.dart';
import '../main.dart';

void loginUser(num userId, num roleId) async {
  OneSignal.login(userId.toString());

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  try {
    await pusher.init(
      apiKey: PUSHER_API_KEY,
      cluster: PUSHER_API_CLUSTER,
      onEvent: (event) {
        logger.i(event);
      },
    );

    if (roleId == 1) {
      await pusher.subscribe(channelName: 'admin-channel');
    } else {
      await pusher.subscribe(channelName: 'user-channel.$userId');
    }

    await pusher.connect();
  } catch (e) {
    logger.e(e);
  }
}

void logoutUser() {
  OneSignal.logout();

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  try {
    pusher.disconnect();
  } catch (e) {
    logger.e(e);
  }

  UserToken.deleteToken();
  UserBox.deleteUser();
}

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
