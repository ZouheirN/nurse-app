import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';

class ImmediateOrderPage extends StatelessWidget {
  const ImmediateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Order #1'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const LabeledDropdown(
                    label: 'Select Nurse',
                    services: [
                      'Nurse 1',
                      'Nurse 2',
                      'Nurse 3',
                      'Nurse 4',
                      'Nurse 5',
                      'Nurse 6',
                    ],
                  ),
                  const SizedBox(height: 10),
                  const LabeledDropdown(
                    label: 'Select Service',
                    services: [
                      'Service 1',
                      'Service 2',
                      'Service 3',
                      'Service 4',
                      'Service 5',
                      'Service 6',
                    ],
                  ),
                  const SizedBox(height: 20),
                  const LabeledTextfield(
                    label: 'Time to arrive',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/scheduledOrder');
                    },
                    buttonText: 'Submit',
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
