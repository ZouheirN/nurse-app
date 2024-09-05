import 'package:flutter/material.dart';
import 'package:nurse_app/components/phone_field_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/third_button.dart';

class EditNursePage extends StatelessWidget {
  const EditNursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Edit Nurse',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const LabeledTextfieldAdmin(
                    label: 'Nurse Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  const PhoneFieldAdmin(),
                  const LabeledTextfieldAdmin(
                    label: 'Nurse Address',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {},
                    buttonText: 'Update Nurse',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
