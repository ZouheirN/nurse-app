import 'package:flutter/material.dart';
import 'package:nurse_app/components/gender_selection_field.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/service_card.dart';
import 'package:nurse_app/components/third_button.dart';

class ImmediateRequestPage extends StatelessWidget {
  const ImmediateRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Service> services = [
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 1',
        price: 20,
        salePrice: 15,
      ),
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 2',
        price: 30,
        salePrice: 25,
      ),
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 3',
        price: 40,
        salePrice: null,
      ),
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 4',
        price: 50,
        salePrice: 45,
      ),
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 5',
        price: 60,
        salePrice: 50,
      ),
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 6',
        price: 70,
        salePrice: 65,
      ),
      Service(
        imagePath: 'assets/images/logo.png',
        title: 'Service 7',
        price: 80,
        salePrice: null,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
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
              const GenderSelectionField(),
              const SizedBox(height: 7),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Select Service',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: services.map((service) {
                    return ServiceCard(
                      imagePath: service.imagePath,
                      title: service.title,
                      price: service.price,
                      salePrice: service.salePrice,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                onTap: () {
                  Navigator.pushNamed(context, '/pendingPage');
                },
                buttonText: 'Submit',
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class Service {
  final String imagePath;
  final String title;
  final int price;
  final int? salePrice;

  Service({
    required this.imagePath,
    required this.title,
    required this.price,
    this.salePrice,
  });
}
