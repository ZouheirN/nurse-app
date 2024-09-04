import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/consts.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void signup(String name, String phoneNumber, String email, String password,
      String passwordConfirmation, BuildContext context) async {
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(KEY_USER_EMAIL, email);

        Navigator.pushReplacementNamed(context, '/verifyEmail');
      } else {
        _showErrorDialog(context, 'Sign Up Failed',
            'Failed to sign up. Please check your information and try again.');
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, 'Error',
          'An error occurred. Please check your connection and try again later.');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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
                inputType: TextInputType.text,
                obscureText: false,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: phoneNumberController,
                icon: const Icon(Icons.phone_outlined),
                hintText: 'Phone Number',
                inputType: TextInputType.phone,
                obscureText: false,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: emailController,
                icon: const Icon(Icons.mail_outline),
                hintText: 'Email',
                inputType: TextInputType.emailAddress,
                obscureText: false,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: passwordController,
                icon: const Icon(Icons.lock_outline),
                hintText: 'Password',
                inputType: TextInputType.text,
                obscureText: true,
              ),
              const SizedBox(height: 14),
              MyTextField(
                controller: passwordConfirmationController,
                icon: const Icon(Icons.lock_outline),
                hintText: 'Confirm Password',
                inputType: TextInputType.text,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              MyButton(
                onTap: () {
                  signup(
                      nameController.text,
                      phoneNumberController.text,
                      emailController.text,
                      passwordController.text,
                      passwordConfirmationController.text,
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
