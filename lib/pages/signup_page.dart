import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/consts.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  void signup(String name, phoneNumber, email, password, passwordConfirmation,
      BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$HOST/register'),
        body: {
          'name': name,
          'phone_number': phoneNumber,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final token = jsonData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(KEY_ACCESS_TOKEN, token);

        Navigator.pushNamed(context, '/home');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign Up Failed'),
              content: const Text('Failed to sign up. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
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
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  'Please register to login',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: nameController,
                icon: const Icon(Icons.person_outlined),
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: phoneNumberController,
                icon: const Icon(Icons.phone_outlined),
                hintText: 'Phone Number',
                obscureText: false,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: emailController,
                icon: const Icon(Icons.mail_outline),
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: passwordController,
                icon: const Icon(Icons.lock_outline),
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: passwordConfirmationController,
                icon: const Icon(Icons.lock_outline),
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              MyButton(
                onTap: () {
                  signup(
                      nameController.text.toString(),
                      phoneNumberController.text.toString(),
                      emailController.text.toString(),
                      passwordController.text.toString(),
                      passwordConfirmationController.text.toString(),
                      context);
                },
                buttonText: 'Sign Up',
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Sign in',
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
