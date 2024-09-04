import 'package:flutter/material.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/third_button.dart';

class ImmediateRequestPage extends StatelessWidget {
  const ImmediateRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: () {},
                      ),
                      const Text(
                        'Beirut, Lebanon',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF7BB442),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {},
                  ),
                  const Text(
                    'Welcome Back User',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/image1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Text(
                            'Request your Nurse Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              MySecondButton(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                buttonText: 'Immediate Request',
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Please fill the below form:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const LabeledTextfield(
                label: 'Full Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 7),
              const PhoneNumberField(),
              const SizedBox(height: 7),
              const LabeledTextfield(
                label: 'Describe your problem',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 7),
              const LabeledTextfield(
                label: 'Address',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 7),
              const LabeledDropdown(
                services: [
                  'service 1',
                  'service 2',
                  'service 3',
                  'service 4',
                  'service 5',
                  'service 6',
                ],
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                onTap: () {
                  Navigator.pushNamed(context, '/pendingPage');
                },
                buttonText: 'Submit',
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
