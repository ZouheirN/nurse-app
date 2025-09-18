import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../main.dart';
import 'package:path_provider/path_provider.dart';

class Dialogs {
  static Future<void> showPopup({
    required BuildContext context,
    required String? image,
    required String? title,
    required String? content,
    required String? type,
  }) async {
    if (image != null) {
      try {
        final path = '${(await getTemporaryDirectory()).path}/${image.split('/').last}';

        // final response = await dio.download(
        //   image,
        //   path,
        // );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title ?? ''),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(File(path)),
                  const SizedBox(height: 16),
                  Text(content ?? ''),
                ],
              ),
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
        return;
      } on DioException catch (e) {
        logger.e('Failed to download image: ${e.message}');
      }
    }

    switch (type) {
      case 'info':
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: title ?? '',
          text: content ?? '',
          confirmBtnText: 'OK',
        );
        break;
      default:
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: title ?? '',
          text: content ?? '',
          confirmBtnText: 'OK',
        );
        break;
    }
  }

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
        if (completeNumber.isEmpty) {
          showErrorDialog(
            context,
            'Phone Number Required',
            'Please enter your phone number',
          );
          return;
        }

        Navigator.pushReplacementNamed(
          context,
          '/forgotPassword',
          arguments: completeNumber.trim(),
        );
      },
      text: 'Enter your phone number to reset your password',
      title: 'Forgot Password',
    );
  }

  static void showVerifySmsDialog(BuildContext context) {
    final phoneNumberController = TextEditingController();
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
        if (completeNumber.isEmpty) {
          showErrorDialog(
            context,
            'Phone Number Required',
            'Please enter your phone number',
          );
          return;
        }

        Navigator.pushReplacementNamed(
          context,
          '/verifySms',
          arguments: {
            'phoneNumber': completeNumber.trim(),
            'resend': true,
          },
        );
      },
      text: 'Enter your phone number to verify your account',
      title: 'Verify Account',
    );
  }
}
