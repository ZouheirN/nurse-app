import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/features/authentication/cubit/authentication_cubit.dart';
import 'package:pinput/pinput.dart';

import '../../utilities/dialogs.dart';

class VerifySmsPage extends StatefulWidget {
  final String phoneNumber;
  final bool resend;

  const VerifySmsPage({
    super.key,
    required this.phoneNumber,
    required this.resend,
  });

  @override
  State<VerifySmsPage> createState() => _VerifySmsPageState();
}

class _VerifySmsPageState extends State<VerifySmsPage> {
  final _authenticationCubit = AuthenticationCubit();

  @override
  void initState() {
    if (widget.resend) {
      _authenticationCubit.resendOtp(widget.phoneNumber).then(
        (value) {
          if (value == false) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to resend OTP'),
              ),
            );
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Verify Phone Number',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the code you received',
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
                  if (state is AuthenticationOtpSuccess) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  } else if (state is AuthenticationOtpFailure) {
                    Dialogs.showErrorDialog(
                      context,
                      'Verification Failed',
                      state.message,
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthenticationOtpLoading;

                  return Column(
                    children: [
                      Pinput(
                        onCompleted: (pin) {
                          if (isLoading) return;

                          _authenticationCubit.verifyOtp(
                            phoneNumber: widget.phoneNumber,
                            pin: pin,
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
