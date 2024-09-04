import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/consts.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

  bool isCodeComplete() {
    return controllers.every((controller) => controller.text.isNotEmpty);
  }

  void verifyEmail(String confirmationCode, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(KEY_USER_EMAIL);

      if (email != null) {
        final response = await http.post(
          Uri.parse('$HOST/verify-email'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'confirmation_code': confirmationCode,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pushNamed(context, '/home');
        } else {
          _showErrorDialog(context, 'Verification Failed',
              'The confirmation code you entered is incorrect.');
        }
      } else {
        _showErrorDialog(
            context, 'Error', 'No email found. Please try again later.');
      }
    } catch (e) {
      print(e.toString());
      _showErrorDialog(
          context, 'Error', 'An error occurred. Please try again later.');
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the code sent to your email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: controllers[index].text.isNotEmpty
                              ? const Color(0xFF7BB442)
                              : Colors.grey,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7BB442),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: isCodeComplete()
                  ? () {
                      String code = controllers.map((c) => c.text).join();
                      verifyEmail(code, context);
                    }
                  : null,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
