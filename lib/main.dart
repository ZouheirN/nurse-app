import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/l10n/l10n.dart';
import 'package:nurse_app/pages/admin/add_nurse_page.dart';
import 'package:nurse_app/pages/admin/add_service_page.dart';
import 'package:nurse_app/pages/admin/admin_dashboard_page.dart';
import 'package:nurse_app/pages/admin/admin_settings_page.dart';
import 'package:nurse_app/pages/admin/areas_page.dart';
import 'package:nurse_app/pages/admin/contact_submissions_page.dart';
import 'package:nurse_app/pages/admin/edit_nurse_page.dart';
import 'package:nurse_app/pages/admin/edit_service_page.dart';
import 'package:nurse_app/pages/admin/manage_nurses_page.dart';
import 'package:nurse_app/pages/admin/manage_orders_page.dart';
import 'package:nurse_app/pages/admin/manage_services_page.dart';
import 'package:nurse_app/pages/admin/order_details_page.dart';
import 'package:nurse_app/pages/admin/region_pricing_page.dart';
import 'package:nurse_app/pages/admin/sliders_page.dart';
import 'package:nurse_app/pages/admin/submit_order_page.dart';
import 'package:nurse_app/pages/user/chat_page.dart';
import 'package:nurse_app/pages/user/edit_profile_page.dart';
import 'package:nurse_app/pages/user/forgot_password_page.dart';
import 'package:nurse_app/pages/user/login_page.dart';
import 'package:nurse_app/pages/user/navbar.dart';
import 'package:nurse_app/pages/user/notifications_page.dart';
import 'package:nurse_app/pages/user/request_details_page.dart';
import 'package:nurse_app/pages/user/signup_page.dart';
import 'package:nurse_app/pages/user/splash_screen.dart';
import 'package:nurse_app/pages/user/update_location_page.dart';
import 'package:nurse_app/pages/user/verify_sms_page.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/utilities/localization_box.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'pages/admin/send_notification_page.dart';

final logger = Logger();
final dio = Dio();

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox('userBox');
  await Hive.openBox('localizationBox');

  if (!kIsWeb) {
    OneSignal.initialize(ONE_SIGNAL_APP_ID);
    OneSignal.Notifications.requestPermission(true);
  }

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

  runApp(
    DevicePreview(
      enabled: !kReleaseMode && kIsWeb,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _onKey(KeyEvent event) {
    final key = event.logicalKey;

    if (event is KeyDownEvent) {
      if (key == LogicalKeyboardKey.f9) {
        DevicePreview.screenshot(context).then(
          (value) async {
            await FileSaver.instance.saveFile(
              name: 'screenshot.png',
              bytes: value.bytes,
            );
          },
        );
      }
    }

    return false;
  }

  @override
  void initState() {
    // GeneralStream.languageStream.add(const Locale('en'));
    if (kDebugMode) {
      ServicesBinding.instance.keyboard.addHandler(_onKey);
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        // onRequest: (options, handler) {
        //   options.headers['Accept'] = 'application/json';
        //
        //   return handler.next(options);
        // },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            logger.w('Unauthorized access detected: ${error.response?.data}');
            // Handle unauthorized access, e.g., redirect to login
            logoutUser();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }

          return handler.next(error);
        },
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    // GeneralStream.languageStream.close();
    if (kDebugMode) {
      ServicesBinding.instance.keyboard.removeHandler(_onKey);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // stream: GeneralStream.languageStream.stream,
      valueListenable: LocalizationBox.getLocaleNotifier(),
      builder: (context, value, child) {
        final locale = LocalizationBox.getLocale();

        return MaterialApp(
          useInheritedMediaQuery: true,
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          locale: locale ?? DevicePreview.locale(context),
          supportedLocales: L10n.locals,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
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
            '/notifications': (context) {
              final args = ModalRoute.of(context)?.settings.arguments as Map?;

              return NotificationsPage(
                showLeading: args?['showLeading'],
              );
            },
            '/manageAreas': (context) => const AreasPage(),
            '/contactSubmissions': (context) => const ContactSubmissionsPage(),
            '/sliders': (context) => const SlidersPage(),
            '/chat': (context) {
              // final args = ModalRoute.of(context)?.settings.arguments as int;
              return const ChatPage();
            },
          },
        );
      },
    );
  }
}
