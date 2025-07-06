import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/textfield.dart';

import '../../features/authentication/cubit/authentication_cubit.dart';
import '../../utilities/dialogs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _authenticationCubit = AuthenticationCubit();

  void login(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      _authenticationCubit.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/header_background.png'),
                fit: BoxFit.cover,
                opacity: 0.32,
                colorFilter: ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.hardLight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image(
                          image: AssetImage('assets/images/square_logo.png'),
                          height: 150,
                          width: 300,
                        ),
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
                          fontStyle: FontStyle.italic,
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: passwordController,
                      icon: const Icon(Icons.lock_outline),
                      hintText: 'Password',
                      inputType: TextInputType.text,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    BlocConsumer<AuthenticationCubit, AuthenticationState>(
                      bloc: _authenticationCubit,
                      listener: (context, state) {
                        if (state is AuthenticationSignInSuccess) {
                          if (state.userModel.roleId == 1) {
                            Navigator.pushReplacementNamed(
                                context, '/adminDashboard');
                          } else if (state.userModel.roleId == 2) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        } else if (state is AuthenticationSignInFailure) {
                          if (state.message ==
                              "Your phone number is not verified.") {
                            Dialogs.showVerifySmsDialog(context);
                          } else {
                            Dialogs.showErrorDialog(
                              context,
                              'Error Logging In',
                              state.message,
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is AuthenticationSignInLoading;

                        return MyButton(
                          isLoading: isLoading,
                          onTap: () {
                            login(context);
                          },
                          buttonText: 'Login',
                        );
                      },
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
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7BB442),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Dialogs.showForgotPasswordDialog(context);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7BB442),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
