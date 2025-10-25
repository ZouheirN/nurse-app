import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nurse_app/services/user.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../consts.dart';
import '../firebase_options.dart';
import 'user_token.dart' as ut;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    final user = UserBox.getUser();
    if (user == null) return;

    final streamVideo = StreamVideo.create(
      Consts.streamApiKey,
      user: User.regular(
        userId: user.id.toString(),
        // userId: user.id.toString(),
        role: user.roleId == 1 ? 'admin' : 'user',
        name: user.name,
      ),
      userToken: await ut.UserToken.getToken(),
      options: const StreamVideoOptions(
        keepConnectionsAliveWhenInBackground: true,
      ),
      pushNotificationManagerProvider:
          StreamVideoPushNotificationManager.create(
        iosPushProvider:
            StreamVideoPushProvider.apn(name: Consts.iosPushProviderName),
        androidPushProvider:  StreamVideoPushProvider.firebase(
            name: Consts.androidPushProviderName),
        pushParams: const StreamVideoPushParams(
          appName: 'Al Ahmad',
          ios: IOSParams(iconName: 'IconMask'),
        ),
      ),
    )..connect();

    final subscription = streamVideo.observeCallDeclinedCallKitEvent();
    streamVideo.disposeAfterResolvingRinging(
      disposingCallback: () => subscription?.cancel(),
    );

    await streamVideo.handleRingingFlowNotifications(message.data);
  } catch (e, stk) {
    debugPrint('Error handling remote message: $e');
    debugPrint(stk.toString());
  }
}
