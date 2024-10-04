import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/dialogs.dart';

import '../../features/authentication/cubit/authentication_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  String completeNumber = '';

  final _formKey = GlobalKey<FormState>();

  final _authenticationCubit = AuthenticationCubit();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void signup() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      _authenticationCubit.signUp(
        phoneNumber: completeNumber.trim(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  inputType: TextInputType.name,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                PhoneNumberField(
                  controller: phoneNumberController,
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  showLabel: false,
                  fillColor: const Color(0xFFE8FFD1),
                  outlineColor: const Color(0xFF7BB442),
                  setCompleteNumber: (number) {
                    completeNumber = number;
                  },
                ),
                const SizedBox(height: 14),
                MyTextField(
                  controller: emailController,
                  icon: const Icon(Icons.mail_outline),
                  hintText: 'Email',
                  inputType: TextInputType.emailAddress,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),
                MyTextField(
                  controller: passwordController,
                  icon: const Icon(Icons.lock_outline),
                  hintText: 'Password',
                  inputType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                MyTextField(
                  controller: passwordConfirmationController,
                  icon: const Icon(Icons.lock_outline),
                  hintText: 'Confirm Password',
                  inputType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  bloc: _authenticationCubit,
                  listener: (context, state) {
                    if (state is AuthenticationSignUpSuccess) {
                      final phoneNumber = state.phoneNumber;
                      Navigator.pushNamed(
                        context,
                        '/verifySms',
                        arguments: {
                          'phoneNumber': phoneNumber,
                          'resend': false,
                        },
                      );
                    } else if (state is AuthenticationSignUpFailure) {
                      Dialogs.showErrorDialog(
                        context,
                        'Sign Up Failed',
                        state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthenticationSignUpLoading;

                    return MyButton(
                      isLoading: isLoading,
                      onTap: () {
                        signup();
                      },
                      buttonText: 'Sign Up',
                    );
                  },
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
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7BB442),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
