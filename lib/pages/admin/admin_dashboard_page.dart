import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/logout_button.dart';
import 'package:nurse_app/consts.dart';

import '../../main.dart';
import '../../services/user.dart';
import '../../services/user_token.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/nurse.png',
                        text: 'Manage Nurses',
                        onTap: () {
                          Navigator.pushNamed(context, '/manageNurses');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/register.png',
                        text: 'Manage Services',
                        onTap: () {
                          Navigator.pushNamed(context, '/manageServices');
                        },
                      ),
                      const SizedBox(height: 20),
                      AdminCard(
                        imagePath: 'assets/images/job-application.png',
                        text: 'Manage Orders',
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
                      AdminCard(
                        imagePath: 'assets/images/notification.png',
                        text: 'Notifications',
                        onTap: () {
                          Navigator.pushNamed(context, '/sendNotification');
                        },
                      ),
                      const SizedBox(height: 20),
                      LogoutButton(
                        icon: const Icon(Icons.logout),
                        buttonText: 'Logout',
                        onTap: () {
                          logoutUser();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/manageAreas');
              },
              child: const Text('Go to Areas Page'),
            ),
            ElevatedButton(
              onPressed: () async {
                // open image picker
                final imagePicker = ImagePicker();

                final pickedFile = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );

                final formData = FormData.fromMap({
                  'image': await MultipartFile.fromFile(
                    pickedFile!.path,
                    filename: pickedFile.name,
                  ),
                  'title': 'Test Popup',
                  'content': 'This is a test popup content.',
                  'type': 'info',
                });

                final token = await UserToken.getToken();

                try {
                  final response = await dio.post(
                    '$HOST/admin/popups',
                    data: formData,
                    options: Options(
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Accept': 'application/json',
                      },
                    ),
                  );

                  logger.i('Popup created: ${response.data}');
                } on DioException catch (e) {
                  logger.e(e.response?.statusCode);
                  logger.e('Failed to create popup: ${e.response?.data}');
                } catch (e) {
                  logger.e('Error creating popup: $e');
                }
              },
              child: const Text('Test Popup'),
            ),
            Column(
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
          ],
        ),
      ),
    );
  }
}
