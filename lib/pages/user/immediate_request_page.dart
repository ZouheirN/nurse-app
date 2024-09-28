import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/gender_selection_field.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/service_card.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:quickalert/quickalert.dart';

import '../../services/user_token.dart';

class ImmediateRequestPage extends StatefulWidget {
  const ImmediateRequestPage({super.key});

  @override
  State<ImmediateRequestPage> createState() => _ImmediateRequestPageState();
}

class _ImmediateRequestPageState extends State<ImmediateRequestPage> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  final locationController = TextEditingController();
  final genderController = GenderSelectionController();

  List<int> selectedServiceIds = [];

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneNumberController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void createRequest(String name, String phoneNumber, String location,
      String problemDescription, BuildContext context) async {
    try {
      final token = await UserToken.getToken();

      final response = await http.post(
        Uri.parse('$HOST/requests'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone_number': phoneNumber,
          'location': location,
          'problem_description': problemDescription,
          'gender': genderController.getGender(),
          'service_ids': selectedServiceIds,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pushNamed(context, '/pendingPage');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'];

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: errorMessage,
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred, please try again later.',
      );
    }
  }

  Future<void> fetchServices() async {
    final token = await UserToken.getToken();

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
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to fetch services.',
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
              LabeledTextfield(
                label: 'Full Name',
                keyboardType: TextInputType.name,
                controller: nameController,
              ),
              const SizedBox(height: 7),
              PhoneNumberField(controller: phoneNumberController),
              const SizedBox(height: 7),
              LabeledTextfield(
                label: 'Describe your problem',
                keyboardType: TextInputType.text,
                controller: problemDescriptionController,
              ),
              const SizedBox(height: 7),
              LabeledTextfield(
                label: 'Address',
                keyboardType: TextInputType.text,
                controller: locationController,
              ),
              const SizedBox(height: 7),
              GenderSelectionField(controller: genderController),
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
                      ? const Loader()
                      : Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: services.map((service) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ServiceCard(
                                serviceId: service['id'],
                                imagePath: service['service_pic'] ??
                                    'assets/images/square_logo.png',
                                title: service['name'],
                                price: service['price'],
                                salePrice: service['discount_price'],
                                onSelectionChanged: (isSelected) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedServiceIds.add(service['id']);
                                    } else {
                                      selectedServiceIds.remove(service['id']);
                                    }
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                onTap: () {
                  createRequest(
                    nameController.text,
                    phoneNumberController.text,
                    locationController.text,
                    problemDescriptionController.text,
                    context,
                  );
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
