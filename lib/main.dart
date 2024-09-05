import 'package:flutter/material.dart';
import 'package:nurse_app/pages/admin/admin_dashboard_page.dart';
import 'package:nurse_app/pages/user/immediate_request_details_page.dart';
import 'package:nurse_app/pages/user/notification_page.dart';
import 'package:nurse_app/pages/user/pending_page.dart';
import 'package:nurse_app/pages/user/scheduled_request_details_page.dart';
import 'package:nurse_app/pages/user/splash_screen.dart';
import 'package:nurse_app/pages/user/login_page.dart';
import 'package:nurse_app/pages/user/signup_page.dart';
import 'package:nurse_app/pages/user/navbar.dart';
import 'package:nurse_app/pages/user/immediate_request_page.dart';
import 'package:nurse_app/pages/user/make_appointment_page.dart';
import 'package:nurse_app/pages/user/verify_email_page.dart';
import 'package:nurse_app/pages/user/update_location_page.dart';
import 'package:nurse_app/pages/user/edit_profile_page.dart';

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
        '/editProfile' : (context) => const EditProfilePage(),
        '/updateLocation' : (context) => const UpdateLocationPage(),
        '/adminDashboard' : (context) => const AdminDashboardPage(),
      },
    );
  }
}
