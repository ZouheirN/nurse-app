import 'package:flutter/material.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/textfield.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
              const MyTextField(
                icon: Icon(Icons.person_outlined),
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 14),
              const MyTextField(
                icon: Icon(Icons.phone_outlined),
                hintText: 'Phone Number',
                obscureText: false,
              ),
              const SizedBox(height: 14),
              const MyTextField(
                icon: Icon(Icons.mail_outline),
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 14),
              const MyTextField(
                icon: Icon(Icons.lock_outline),
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              MyButton(
                onTap: () {},
                buttonText: 'Signup',
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
