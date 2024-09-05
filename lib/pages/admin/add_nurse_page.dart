import 'package:flutter/material.dart';
import 'package:nurse_app/components/phone_field_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';

class AddNursePage extends StatelessWidget {
  const AddNursePage({super.key});

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
          'Add New Nurse',
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
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  LabeledTextfieldAdmin(
                    label: 'Nurse Name',
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 10),
                  PhoneFieldAdmin(),
                  LabeledTextfieldAdmin(
                    label: 'Nurse Address',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
