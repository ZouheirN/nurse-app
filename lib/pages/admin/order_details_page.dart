import 'package:flutter/material.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/labeled_mini_textfield_order.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

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
                  const LabeledTextfield(
                    label: 'Full Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  const PhoneNumberField(),
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
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {},
                    buttonText: 'Accept',
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
