import 'package:flutter/material.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';

class ImmediateOrderPage extends StatelessWidget {
  const ImmediateOrderPage({super.key});

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
          'Order #1',
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
