import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            AdminCard(
              imagePath: 'assets/images/nurse.png',
              text: 'Manage Nurses',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            AdminCard(
              imagePath: 'assets/images/register.png',
              text: 'Manage Services',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            AdminCard(
              imagePath: 'assets/images/job-application.png',
              text: 'Manage Orders',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
