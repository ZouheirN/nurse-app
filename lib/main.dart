import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
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
import 'package:nurse_app/pages/user/edit_profile_page.dart';
import 'package:nurse_app/pages/user/forgot_password_page.dart';
import 'package:nurse_app/pages/user/immediate_request_details_page.dart';
import 'package:nurse_app/pages/user/immediate_request_page.dart';
import 'package:nurse_app/pages/user/login_page.dart';
import 'package:nurse_app/pages/user/make_appointment_page.dart';
import 'package:nurse_app/pages/user/navbar.dart';
import 'package:nurse_app/pages/user/notification_page.dart';
import 'package:nurse_app/pages/user/pending_page.dart';
import 'package:nurse_app/pages/user/scheduled_request_details_page.dart';
import 'package:nurse_app/pages/user/signup_page.dart';
import 'package:nurse_app/pages/user/splash_screen.dart';
import 'package:nurse_app/pages/user/update_location_page.dart';
import 'package:nurse_app/pages/user/verify_sms_page.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

final logger = Logger();

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox('userBox');

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  try {
    await pusher.init(
      apiKey: PUSHER_API_KEY,
      cluster: PUSHER_API_CLUSTER,
    );
    // await pusher.subscribe(channelName: 'presence-chatbox');
    // await pusher.connect();
  } catch (e) {
    logger.e(e);
  }


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
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const Navbar(),
        '/immediateRequest': (context) => const ImmediateRequestPage(),
        '/makeAppointment': (context) => const MakeAppointmentPage(),
        '/pendingPage': (context) => const PendingPage(),
        '/notification': (context) => const NotificationPage(),
        '/verifySms': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;
          return VerifySmsPage(phoneNumber: args);
        },
        '/forgotPassword': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;
          return ForgotPasswordPage(phoneNumber: args);
        },
        '/immediateRequestDetails': (context) =>
            const ImmediateRequestDetailsPage(),
        '/scheduledRequestDetails': (context) =>
            const ScheduledRequestDetailsPage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/updateLocation': (context) => const UpdateLocationPage(),
        '/adminDashboard': (context) => const AdminDashboardPage(),
        '/manageNurses': (context) => const ManageNursesPage(),
        '/addNurse': (context) => const AddNursePage(),
        '/editNurse': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int;
          return EditNursePage(nurseId: args);
        },
        '/manageServices': (context) => const ManageServicesPage(),
        '/addService': (context) => const AddServicePage(),
        '/editService': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int;
          return EditServicePage(serviceId: args);
        },
        '/manageOrders': (context) => const ManageOrdersPage(),
        '/orderDetails': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int;
          return OrderDetailsPage(orderId: args);
        },
        '/immediateOrder': (context) => const ImmediateOrderPage(),
        '/scheduledOrder': (context) => const ScheduledOrderPage(),
        '/orderProcess': (context) => const OrderProcessPage(),
        '/adminSettings': (context) => const AdminSettingsPage(),
      },
    );
  }
}
