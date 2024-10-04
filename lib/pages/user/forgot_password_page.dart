import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/features/authentication/cubit/authentication_cubit.dart';
import 'package:pinput/pinput.dart';

import '../../components/textfield.dart';
import '../../utilities/dialogs.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String phoneNumber;

  const ForgotPasswordPage({super.key, required this.phoneNumber});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _authenticationCubit = AuthenticationCubit();
  final _authenticationCubit2 = AuthenticationCubit();

  @override
  void initState() {
    _authenticationCubit.sendForgotPasswordOtp(phoneNumber: widget.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the code you received and your new password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthenticationCubit, AuthenticationState>(
                bloc: _authenticationCubit,
                listener: (context, state) {
                  if (state is AuthenticationForgotPasswordOtpFailure) {
                    Dialogs.showErrorDialog(
                      context,
                      'Verification Failed',
                      state.message,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthenticationForgotPasswordOtpSuccess) {
                    return _buildPinInput();
                  }

                  return const Column(
                    children: [
                      Text(
                        'Sending OTP...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Loader(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinInput() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit2,
      listener: (context, state) {
        if (state is AuthenticationOtpFailure) {
          Dialogs.showErrorDialog(
            context,
            'Verification Failed',
            state.message,
          );
        } else if (state is AuthenticationOtpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful. Please login.'),
            ),
          );

          Navigator.pushReplacementNamed(
            context,
            '/login',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthenticationOtpLoading;

        return Form(
          key: formKey,
          child: Column(
            children: [
              _buildResetPasswordFields(
                  passwordController, confirmPasswordController, formKey),
              const SizedBox(height: 20),
              Pinput(
                onCompleted: (pin) {
                  if (!formKey.currentState!.validate()) return;

                  if (isLoading) return;

                  _authenticationCubit2.verifyForgotPasswordOtp(
                    phoneNumber: widget.phoneNumber,
                    pin: pin,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                },
                length: 6,
                keyboardType: TextInputType.number,
                enabled: !isLoading,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF7BB442),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (isLoading)
                const Column(
                  children: [
                    SizedBox(height: 20),
                    Loader(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResetPasswordFields(TextEditingController passwordController,
      TextEditingController confirmPasswordController, formKey) {
    return Column(
      children: [
        MyTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your new password';
            }

            return null;
          },
          controller: passwordController,
          hintText: 'New Password',
          icon: const Icon(Icons.lock_outline),
          inputType: TextInputType.text,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        MyTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            }

            if (value != passwordController.text) {
              return 'Passwords do not match';
            }

            return null;
          },
          controller: confirmPasswordController,
          hintText: 'Confirm Password',
          icon: const Icon(Icons.lock_outline),
          inputType: TextInputType.text,
          obscureText: true,
        ),
      ],
    );
  }
}
