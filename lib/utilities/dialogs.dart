import 'package:flutter/material.dart';
import 'package:nurse_app/components/phone_number_field.dart';
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

  static void showSuccessDialog(
    BuildContext context,
    String title,
    String message, {
    void Function()? onConfirmBtnTap,
  }) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message,
      title: title,
      onConfirmBtnTap: onConfirmBtnTap,
    );
  }

  static void showForgotPasswordDialog(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String completeNumber = '';

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      widget: PhoneNumberField(
        controller: phoneNumberController,
        setCompleteNumber: (number) {
          completeNumber = number;
        },
        showLabel: false,
        padding: const EdgeInsets.only(top: 10),
      ),
      onConfirmBtnTap: () {
        if (formKey.currentState!.validate()) {
          Navigator.pushReplacementNamed(
            context,
            '/forgotPassword',
            arguments: completeNumber.trim(),
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

    String completeNumber = '';

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      widget: PhoneNumberField(
        controller: phoneNumberController,
        setCompleteNumber: (number) {
          completeNumber = number;
        },
        showLabel: false,
        padding: const EdgeInsets.only(top: 10),
      ),
      onConfirmBtnTap: () {
        if (formKey.currentState!.validate()) {
          Navigator.pushReplacementNamed(
            context,
            '/verifySms',
            arguments: {
              'phoneNumber': completeNumber.trim(),
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
