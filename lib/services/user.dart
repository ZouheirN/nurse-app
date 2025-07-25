import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:nurse_app/features/authentication/cubit/authentication_cubit.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void loginUser(num userId, num roleId) async {
  if (!kIsWeb) {
    OneSignal.login(userId.toString());
  }

  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  // try {
  //   await pusher.init(
  //     apiKey: PUSHER_API_KEY,
  //     cluster: PUSHER_API_CLUSTER,
  //     onEvent: (event) {
  //       logger.i(event);
  //     },
  //   );
  //
  //
  //   if (roleId == 1) {
  //     await pusher.subscribe(channelName: 'admin-channel');
  //   } else {
  //     await pusher.subscribe(channelName: 'user-channel.$userId');
  //   }
  //
  //   await pusher.connect();
  // } catch (e) {
  //   logger.e(e);
  // }
}

void logoutUser() {
  if (!kIsWeb) {
    OneSignal.logout();
  }
  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  // try {
  //   pusher.disconnect();
  // } catch (e) {
  //   logger.e(e);
  // }

  AuthenticationCubit().signOut();

  UserToken.deleteToken();
  UserBox.deleteUser();
}

class UserBox {
  static final _box = Hive.box('userBox');

  static void saveUser(UserModel user) {
    _box.put('user', user);
  }

  static void setUserLocation(String location) {
    final user = _box.get('user') as UserModel;
    user.location = location;
    _box.put('user', user);
  }

  static void setUserCoordinates(num latitude, num longitude) {
    final user = _box.get('user') as UserModel;
    user.latitude = latitude;
    user.longitude = longitude;
    _box.put('user', user);
  }

  static LatLng getUserCoordinates() {
    final user = _box.get('user') as UserModel?;

    if (user != null) {
      if (user.latitude == null || user.longitude == null) {
        return const LatLng(
            0, 0); // Default coordinates if latitude or longitude is null
      }

      return LatLng(double.parse(user.latitude.toString()),
          double.parse(user.longitude.toString()));
    }

    return const LatLng(0, 0); // Default coordinates if user is not found
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
