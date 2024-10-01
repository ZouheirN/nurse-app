import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Dialogs {
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message,
      title: title,
    );

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text(title),
    //       content: Text(message),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  static void showForgotPasswordDialog(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      widget: Form(
        key: formKey,
        child: TextFormField(
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Phone Number',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }

            if (!value.contains('+')) {
              return 'Please include country code';
            }

            return null;
          },
        ),
      ),
      onConfirmBtnTap: () {
        if (formKey.currentState!.validate()) {
          Navigator.pushReplacementNamed(
            context,
            '/forgotPassword',
            arguments: phoneNumberController.text.trim(),
          );
        }
      },
      text: 'Enter your phone number to reset your password',
      title: 'Forgot Password',
    );
  }

  static void showVerifySmsDialog(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      widget: Form(
        key: formKey,
        child: TextFormField(
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Phone Number',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }

            if (!value.contains('+')) {
              return 'Please include country code';
            }

            return null;
          },
        ),
      ),
      onConfirmBtnTap: () {
        if (formKey.currentState!.validate()) {
          Navigator.pushReplacementNamed(
            context,
            '/verifySms',
            arguments: {
              'phoneNumber': phoneNumberController.text.trim(),
              'resend': true,
            },
          );
        }
      },
      text: 'Enter your phone number to verify your account',
      title: 'Verify Account',
    );
  }
}
