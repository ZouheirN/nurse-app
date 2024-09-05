import 'package:flutter/material.dart';
import 'package:nurse_app/components/logout_button.dart';
import 'package:nurse_app/components/settings_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Center(
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 110,
                        width: 220,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SettingsButton(
                        icon: const Icon(Icons.account_circle),
                        buttonText: 'Account Details',
                        onTap: () {
                          Navigator.pushNamed(context, '/editProfile');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SettingsButton(
                        icon: const Icon(Icons.location_on),
                        buttonText: 'Update Location',
                        onTap: () {
                          Navigator.pushNamed(context, '/updateLocation');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    LogoutButton(
                      icon: const Icon(Icons.logout),
                      buttonText: 'Logout',
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'Powered By',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
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
        ],
      ),
    );
  }
}
