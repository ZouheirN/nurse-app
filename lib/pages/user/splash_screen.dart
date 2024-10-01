import 'package:flutter/material.dart';
import 'package:nurse_app/services/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      final isLoggedIn = UserBox.isUserLoggedIn();

      final user = UserBox.getUser();

      if (isLoggedIn) {
        if (user!.roleId == 1) {
          Navigator.pushReplacementNamed(context, '/adminDashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          // Center Logo
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 300,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Powered By',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Image.asset(
                    'assets/images/powered_by.png',
                    width: 150,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
