import 'package:flutter/material.dart';
import 'package:nurse_app/pages/admin/add_nurse_page.dart';
import 'package:nurse_app/pages/admin/add_service_page.dart';
import 'package:nurse_app/pages/admin/admin_dashboard_page.dart';
import 'package:nurse_app/pages/admin/admin_settings_page.dart';
import 'package:nurse_app/pages/admin/edit_nurse_page.dart';
import 'package:nurse_app/pages/admin/edit_service_page.dart';
import 'package:nurse_app/pages/admin/immediate_order_page.dart';
import 'package:nurse_app/pages/admin/manage_nurses_page.dart';
import 'package:nurse_app/pages/admin/manage_orders_page.dart';
import 'package:nurse_app/pages/admin/manage_services_page.dart';
import 'package:nurse_app/pages/admin/order_details_page.dart';
import 'package:nurse_app/pages/admin/order_process_page.dart';
import 'package:nurse_app/pages/admin/scheduled_order_page.dart';
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
import 'package:nurse_app/pages/user/verify_sms_page.dart';
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
        '/verifySms': (context) => VerifySmsPage(),
        '/immediateRequestDetails' : (context) => const ImmediateRequestDetailsPage(),
        '/scheduledRequestDetails' : (context) => const ScheduledRequestDetailsPage(),
        '/editProfile' : (context) => const EditProfilePage(),
        '/updateLocation' : (context) => const UpdateLocationPage(),
        '/adminDashboard' : (context) => const AdminDashboardPage(),
        '/manageNurses' : (context) => const ManageNursesPage(),
        '/addNurse' : (context) => const AddNursePage(),
        '/editNurse': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int;
          return EditNursePage(nurseId: args);
        },
        '/manageServices' : (context) => const ManageServicesPage(),
        '/addService' : (context) => const AddServicePage(),
        '/editService' :  (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int;
          return EditServicePage(serviceId: args);
        },
        '/manageOrders' : (context) => const ManageOrdersPage(),
        '/orderDetails' : (context) { 
          final args = ModalRoute.of(context)?.settings.arguments as int;
          return OrderDetailsPage(orderId: args);
        },
        '/immediateOrder' : (context) => const ImmediateOrderPage(),
        '/scheduledOrder' : (context) => const ScheduledOrderPage(),
        '/orderProcess' : (context) => const OrderProcessPage(),
        '/adminSettings' : (context) => const AdminSettingsPage(),
      },
    );
  }
}
