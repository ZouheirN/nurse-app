import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/consts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(String email, password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$HOST/login'),
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final token = jsonData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(KEY_ACCESS_TOKEN, token);

        final roleId = jsonData['user']['role_id'];
        if (roleId == 1) {
          Navigator.pushNamed(context, '/adminDashboard');
        } else if (roleId == 2) {
          Navigator.pushNamed(context, '/home');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'];

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: errorMessage,
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred, please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 150,
                  width: 300,
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  'Please Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: emailController,
                icon: const Icon(Icons.mail_outline),
                hintText: 'Email',
                inputType: TextInputType.emailAddress,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                icon: const Icon(Icons.lock_outline),
                hintText: 'Password',
                inputType: TextInputType.text,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              MyButton(
                onTap: () {
                  login(emailController.text.toString(),
                      passwordController.text.toString(), context);
                },
                buttonText: 'Login',
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7BB442),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
