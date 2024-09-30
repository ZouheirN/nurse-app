import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/status_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/labeled_mini_textfield_order.dart';

class OrderProcessPage extends StatelessWidget {
  const OrderProcessPage({super.key});

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
                  const LabeledTextfield(
                    label: 'Full Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  PhoneNumberField(),
                  const LabeledTextfield(
                    label: 'Describe your problem',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  const LabeledTextfield(
                    label: 'Address',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 9,
                          child: LabeledMiniTextfieldOrder(
                            label: 'Service',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: LabeledMiniTextfieldOrder(
                            label: '',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatusButton(
                            onTap: () {},
                            buttonText: 'Pending',
                            color: const Color(0xFF8E8E8E),
                          ),
                          StatusButton(
                            onTap: () {},
                            buttonText: 'Completed',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
