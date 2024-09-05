import 'package:flutter/material.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';
import 'package:nurse_app/components/edit_phone_number_field.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
              'Edit Profile',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  border: Border.all(
                    color: const Color(0xFFD9D9D9),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    SizedBox(height: 10),
                    LabeledEditTextfield(
                      label: 'Username',
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 7),
                    EditPhoneNumberField(),
                    LabeledEditTextfield(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 7),
                    LabeledEditTextfield(
                      label: 'Location',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                onTap: () {},
                buttonText: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
