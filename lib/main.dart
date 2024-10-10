import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/pages/admin/add_nurse_page.dart';
import 'package:nurse_app/pages/admin/add_service_page.dart';
import 'package:nurse_app/pages/admin/admin_dashboard_page.dart';
import 'package:nurse_app/pages/admin/admin_settings_page.dart';
import 'package:nurse_app/pages/admin/edit_nurse_page.dart';
import 'package:nurse_app/pages/admin/edit_service_page.dart';
import 'package:nurse_app/pages/admin/manage_nurses_page.dart';
import 'package:nurse_app/pages/admin/manage_orders_page.dart';
import 'package:nurse_app/pages/admin/manage_services_page.dart';
import 'package:nurse_app/pages/admin/order_details_page.dart';
import 'package:nurse_app/pages/admin/submit_order_page.dart';
import 'package:nurse_app/pages/user/edit_profile_page.dart';
import 'package:nurse_app/pages/user/forgot_password_page.dart';
import 'package:nurse_app/pages/user/login_page.dart';
import 'package:nurse_app/pages/user/navbar.dart';
import 'package:nurse_app/pages/user/request_details_page.dart';
import 'package:nurse_app/pages/user/signup_page.dart';
import 'package:nurse_app/pages/user/splash_screen.dart';
import 'package:nurse_app/pages/user/update_location_page.dart';
import 'package:nurse_app/pages/user/verify_sms_page.dart';
import 'package:nurse_app/services/user.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'pages/admin/send_notification_page.dart';

final logger = Logger();

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox('userBox');

  OneSignal.initialize(ONE_SIGNAL_APP_ID);
  OneSignal.Notifications.requestPermission(true);

  if (UserBox.isUserLoggedIn()) {
    final user = UserBox.getUser();
    loginUser(user!.id!, user.roleId!);
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
              ),
            ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF7BB442),
        ),
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const Navbar(),
        '/verifySms': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map;
          return VerifySmsPage(
            phoneNumber: args['phoneNumber'],
            resend: args['resend'],
          );
        },
        '/forgotPassword': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;
          return ForgotPasswordPage(phoneNumber: args);
        },
        '/requestDetails': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as num;
          return RequestDetailsPage(requestId: args);
        },
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
        '/submitOrder': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as RequestsHistoryModel;
          return SubmitOrderPage(order: args);
        },
        '/adminSettings': (context) => const AdminSettingsPage(),
        '/sendNotification': (context) => const SendNotificationPage(),
      },
    );
  }
}
