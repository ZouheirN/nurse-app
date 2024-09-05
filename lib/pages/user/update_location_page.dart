import 'package:flutter/material.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';

class UpdateLocationPage extends StatelessWidget {
  const UpdateLocationPage({super.key});

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
              'Update Location',
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
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/logo.png',
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 20),
          const LabeledEditTextfield(
            label: 'Enter Your Location',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          MyThirdButton(
            onTap: () {},
            buttonText: 'Save',
          ),
        ]),
      ),
    );
  }
}
