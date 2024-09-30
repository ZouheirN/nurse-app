import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/gender_selection_field.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/labeled_date.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/service_card.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:quickalert/quickalert.dart';

import '../../components/loader.dart';
import '../../components/time_type_selection_field.dart';
import '../../features/request/cubit/request_cubit.dart';
import '../../features/services/cubit/services_cubit.dart';
import '../../services/user_token.dart';

class MakeAppointmentPage extends StatefulWidget {
  const MakeAppointmentPage({super.key});

  @override
  State<MakeAppointmentPage> createState() => _MakeAppointmentPageState();
}

class _MakeAppointmentPageState extends State<MakeAppointmentPage> {
  final nameController = TextEditingController();
  String completeNumber = '';
  final problemDescriptionController = TextEditingController();
  final locationController = TextEditingController();
  final genderController = GenderSelectionController();
  final timeTypeController = TimeTypeSelectionController();

  List<dynamic> services = [];
  bool isLoading = true;

  List<int> selectedServiceIds = [];

  final _requestCubit = RequestCubit();
  final _servicesCubit = ServicesCubit();

  void setCompleteNumber(String number) {
    setState(() {
      completeNumber = number;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _servicesCubit.fetchServices();
    super.initState();
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
          'full_name': name,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
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
                buttonText: 'Make an Appointment',
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
              PhoneNumberField(
                setCompleteNumber: setCompleteNumber,
              ),
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
              TimeTypeSelectionField(controller: timeTypeController),
              const SizedBox(height: 10),
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
                  child: BlocBuilder<ServicesCubit, ServicesState>(
                    bloc: _servicesCubit,
                    builder: (context, state) {
                      if (state is ServicesFetchLoading) {
                        return const Loader();
                      } else if (state is ServicesFetchSuccess) {
                        final services = state.services;

                        return Wrap(
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
                        );
                      } else {
                        return const Text('Failed to fetch services.');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0xFFE7E7E7),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        LabeledDateField(
                          label: 'Start Date',
                          currentDate: DateTime.now(),
                        ),
                        const SizedBox(height: 7),
                        LabeledDateField(
                          label: 'End Date',
                          currentDate: DateTime.now(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                onTap: () {
                  createRequest(
                    nameController.text,
                    completeNumber,
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
