import 'package:flutter/material.dart';
import 'package:nurse_app/pages/immediate_request_details_page.dart';
import 'package:nurse_app/pages/notification_page.dart';
import 'package:nurse_app/pages/pending_page.dart';
import 'package:nurse_app/pages/scheduled_request_details_page.dart';
import 'package:nurse_app/pages/splash_screen.dart';
import 'package:nurse_app/pages/login_page.dart';
import 'package:nurse_app/pages/signup_page.dart';
import 'package:nurse_app/pages/navbar.dart';
import 'package:nurse_app/pages/immediate_request_page.dart';
import 'package:nurse_app/pages/make_appointment_page.dart';
import 'package:nurse_app/pages/verify_email_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => const Navbar(),
        '/immediateRequest': (context) => const ImmediateRequestPage(),
        '/makeAppointment': (context) => const MakeAppointmentPage(),
        '/pendingPage': (context) => const PendingPage(),
        '/notification': (context) => const NotificationPage(),
        '/verifyEmail': (context) => VerifyEmailPage(),
        '/immediateRequestDetails' : (context) => const ImmediateRequestDetailsPage(),
        '/scheduledRequestDetails' : (context) => const ScheduledRequestDetailsPage(),
      },
    );
  }
}
