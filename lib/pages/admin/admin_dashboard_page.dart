import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/logout_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/services/user_token.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

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
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                AdminCard(
                  imagePath: 'assets/images/nurse.png',
                  text: 'Manage Nurses    ',
                  onTap: () {
                    Navigator.pushNamed(context, '/manageNurses');
                  },
                ),
                const SizedBox(height: 20),
                AdminCard(
                  imagePath: 'assets/images/register.png',
                  text: 'Manage Services  ',
                  onTap: () {
                    Navigator.pushNamed(context, '/manageServices');
                  },
                ),
                const SizedBox(height: 20),
                AdminCard(
                  imagePath: 'assets/images/job-application.png',
                  text: 'Manage Orders    ',
                  onTap: () {
                    Navigator.pushNamed(context, '/manageOrders');
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
                LogoutButton(
                  icon: const Icon(Icons.logout),
                  buttonText: 'Logout',
                  onTap: () {
                    logoutUser();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
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
        ],
      ),
    );
  }
}
