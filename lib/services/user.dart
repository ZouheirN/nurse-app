import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:nurse_app/features/authentication/cubit/authentication_cubit.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/services/user_token.dart' as ut;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../consts.dart';
import '../firebase_options.dart';

void loginUser(num userId, num roleId) async {
  if (!kIsWeb) {
    OneSignal.login(userId.toString());
  }

  final user = UserBox.getUser();

  final isAdmin = user?.roleId == 1;

  await StreamVideo.reset(disconnect: true);
  StreamVideo(
    STREAM_API_KEY,
    user: User.regular(
      // userId: user!.id.toString(),
      userId: '2',
      role: isAdmin ? 'admin' : 'user',
      name: user?.name,
    ),
    // userToken:
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.YNCFmWqRfWNwzjWzy8CcsRe6D9aVxL45u8gvuRofVbY',
    userToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMiJ9.2jqV-NqPiD9toEOo8RDu37F--rKxPMkObGKsbvvRUf0',
    options: const StreamVideoOptions(
      keepConnectionsAliveWhenInBackground: true,
    ),
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(
        name: iosPushProviderName,
      ),
      androidPushProvider: const StreamVideoPushProvider.firebase(
        name: androidPushProviderName,
      ),
      pushParams: const StreamVideoPushParams(
        appName: 'Al Ahmad',
        ios: IOSParams(iconName: 'IconMask'),
      ),
      registerApnDeviceToken: true,
    ),
  ).connect();

  // StreamVideo(
  //   'mmhfdzb5evj2',
  //   user: User.regular(userId: 'Separate_Twig', role: 'admin', name: 'John Doe'),
  //   userToken:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL1NlcGFyYXRlX1R3aWciLCJ1c2VyX2lkIjoiU2VwYXJhdGVfVHdpZyIsInZhbGlkaXR5X2luX3NlY29uZHMiOjYwNDgwMCwiaWF0IjoxNzU3MzU2NzE0LCJleHAiOjE3NTc5NjE1MTR9.yRYZKRfnAOOH9XxKckIuJrwJDVkN5HiL45hSFvKmoEw'  );

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

  StreamVideo.instance.disconnect();

  ut.UserToken.deleteToken();
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
