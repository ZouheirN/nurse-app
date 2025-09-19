import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/logout_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:stream_video/stream_video.dart';

import '../../components/call_screen.dart';
import '../../main.dart';
import '../../services/firebase_messaging_handler.dart';
import '../../services/user.dart';
import '../../services/user_token.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final Subscriptions subscriptions = Subscriptions();
  static const int _fcmSubscription = 1;
  static const int _callKitSubscription = 2;

  void _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    subscriptions.add(
      _fcmSubscription,
      FirebaseMessaging.onMessage.listen(_handleRemoteMessage),
    );
  }

  void _observeCallKitEvents() {
    final streamVideo = StreamVideo.instance;

    subscriptions.add(
      _callKitSubscription,
      streamVideo.observeCoreCallKitEvents(
        onCallAccepted: (callToJoin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScreen(
                call: callToJoin,
              ),
            ),
          );
        },
      ),
    );
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    // This is only relevant for Android.
    if (CurrentPlatform.isIos) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      StreamVideo.instance.consumeAndAcceptActiveCall(
        onCallAccepted: (callToJoin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScreen(
                call: callToJoin,
              ),
            ),
          );
        },
      );
    });
  }

  Future<bool> _handleRemoteMessage(RemoteMessage message) async {
    return StreamVideo.instance.handleRingingFlowNotifications(message.data);
  }

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();

    _tryConsumingIncomingCallFromTerminatedState();

    _observeFcmMessages();
    _observeCallKitEvents();

    super.initState();
  }

  @override
  void dispose() {
    subscriptions.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text(
            'Welcome Back Admin',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/nurse.png',
                        text: 'Manage Nurses',
                        onTap: () {
                          Navigator.pushNamed(context, '/manageNurses');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/register.png',
                        text: 'Manage Services',
                        onTap: () {
                          Navigator.pushNamed(context, '/manageServices');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/job-application.png',
                        text: 'Manage Orders',
                        onTap: () {
                          Navigator.pushNamed(context, '/manageOrders');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        // imagePath: 'assets/images/notification.png',
                        text: 'Manage Categories',
                        onTap: () {
                          Navigator.pushNamed(context, '/categories');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/settings.png',
                        text: 'Account Settings',
                        onTap: () {
                          Navigator.pushNamed(context, '/adminSettings');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/notification.png',
                        text: 'Notifications',
                        onTap: () {
                          Navigator.pushNamed(context, '/sendNotification');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        // imagePath: 'assets/images/notification.png',
                        text: 'Manage Areas',
                        onTap: () {
                          Navigator.pushNamed(context, '/manageAreas');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        // imagePath: 'assets/images/notification.png',
                        text: 'Contact Submissions',
                        onTap: () {
                          Navigator.pushNamed(context, '/contactSubmissions');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        // imagePath: 'assets/images/notification.png',
                        text: 'Manage Sliders',
                        onTap: () {
                          Navigator.pushNamed(context, '/sliders');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        // imagePath: 'assets/images/notification.png',
                        text: 'Manage FAQs',
                        onTap: () {
                          Navigator.pushNamed(context, '/faqs');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        // imagePath: 'assets/images/notification.png',
                        text: 'Manage Popups',
                        onTap: () {
                          Navigator.pushNamed(context, '/popups');
                        },
                      ),
                      const SizedBox(height: 20),
                      LogoutButton(
                        icon: const Icon(Icons.logout),
                        buttonText: 'Logout',
                        onTap: () {
                          logoutUser();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // open image picker
            //
            //   },
            //   child: const Text('Test Popup'),
            // ),
            Column(
              children: [
                const Text(
                  'Powered By',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                // const SizedBox(height: 3),
                Image.asset(
                  'assets/images/powered_by.png',
                  width: 150,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
