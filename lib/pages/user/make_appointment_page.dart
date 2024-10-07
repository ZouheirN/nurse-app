import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/gender_selection_field.dart';
import 'package:nurse_app/components/labeled_date.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/utilities/dialogs.dart';
import 'package:quickalert/quickalert.dart';

import '../../components/loader.dart';
import '../../components/services_list.dart';
import '../../components/time_type_selection_field.dart';
import '../../features/request/cubit/request_cubit.dart';
import '../../features/services/cubit/services_cubit.dart';

class MakeAppointmentPage extends StatefulWidget {
  final Function(String) setValue;

  const MakeAppointmentPage({super.key, required this.setValue});

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
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  List<dynamic> services = [];
  List<int> selectedServiceIds = [];

  final _requestCubit = RequestCubit();
  final _servicesCubit = ServicesCubit();

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        widget.setValue('home');
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MySecondButton(
                onTap: () {
                  widget.setValue('home');
                },
                buttonText: 'Make an Appointment',
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
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
                label: 'Patient Full Name',
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }

                  // check if full name
                  if (value.split(' ').length < 2) {
                    return 'Please enter your full name.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 7),
              PhoneNumberField(
                setCompleteNumber: setCompleteNumber,
              ),
              const SizedBox(height: 7),
              LabeledTextfield(
                expand: true,
                label: 'Describe Your Problem',
                keyboardType: TextInputType.multiline,
                controller: problemDescriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your problem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 7),
              LabeledTextfield(
                label: 'Address',
                keyboardType: TextInputType.text,
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address.';
                  }
                  return null;
                },
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

                        return ServicesList(
                          services: services,
                          selectedServiceIds: selectedServiceIds,
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
                          currentDate: startDate,
                          currentTime: TimeOfDay.now(),
                          onPicked: (date) {
                            setState(() {
                              startDate = date;
                            });
                          },
                        ),
                        const SizedBox(height: 7),
                        LabeledDateField(
                          label: 'End Date',
                          currentDate: endDate,
                          currentTime: TimeOfDay.now(),
                          onPicked: (date) {
                            setState(() {
                              endDate = date;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<RequestCubit, RequestState>(
                bloc: _requestCubit,
                listener: (context, state) {
                  if (state is RequestCreateSuccess) {
                    widget.setValue('success');
                  } else if (state is RequestCreateFailure) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is RequestCreateLoading;

                  return MyThirdButton(
                    isLoading: isLoading,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (completeNumber.isEmpty) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please enter your phone number.',
                        );
                        return;
                      }

                      if (genderController.getGender() == null) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please select a gender.',
                        );
                        return;
                      }

                      if (timeTypeController.getTimeType() == null) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please select a time type.',
                        );
                        return;
                      }

                      if (selectedServiceIds.isEmpty) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please select at least one service.',
                        );
                        return;
                      }

                      if (startDate.isAfter(endDate)) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'End date should be after start date.',
                        );
                        return;
                      }

                      _requestCubit.createRequest(
                        name: nameController.text.trim(),
                        phoneNumber: completeNumber,
                        location: locationController.text.trim(),
                        problemDescription:
                            problemDescriptionController.text.trim(),
                        nurseGender: genderController.getGender()!,
                        selectedServices: selectedServiceIds,
                        timeType: timeTypeController.getTimeType()!,
                        startDate: startDate,
                        endDate: endDate,
                      );
                    },
                    buttonText: 'Submit',
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
