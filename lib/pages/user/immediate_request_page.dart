import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/gender_selection_field.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/service_card.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImmediateRequestPage extends StatefulWidget {
  const ImmediateRequestPage({super.key});

  @override
  State<ImmediateRequestPage> createState() => _ImmediateRequestPageState();
}

class _ImmediateRequestPageState extends State<ImmediateRequestPage> {
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.get(
      Uri.parse('$HOST/services'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        services = data['services'];
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fetch Failed'),
            content: const Text('Failed to fetch services.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: services.map((service) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ServiceCard(
                                imagePath: 'assets/images/square_logo.png',
                                title: service['name'],
                                price: service['price'],
                                salePrice: service['discount_price'],
                              ),
                            );
                          }).toList(),
                        ),
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
