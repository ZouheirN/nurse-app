import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Dialogs {
  static void showErrorDialog(BuildContext context, String title, String message) {
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
}