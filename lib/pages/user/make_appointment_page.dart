import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/gender_selection_field.dart';
import 'package:nurse_app/components/labeled_date.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/utilities/dialogs.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/loader.dart';
import '../../components/services_list.dart';
import '../../features/areas/cubit/areas_cubit.dart';
import '../../features/request/cubit/request_cubit.dart';
import '../../features/services/cubit/services_cubit.dart';
import '../../features/services/models/get_services_model.dart';

class MakeAppointmentPage extends StatefulWidget {
  final String category;
  final Function(String?) setValue;

  const MakeAppointmentPage({
    super.key,
    required this.setValue,
    required this.category,
  });

  @override
  State<MakeAppointmentPage> createState() => _MakeAppointmentPageState();
}

class _MakeAppointmentPageState extends State<MakeAppointmentPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String completeNumber = '';
  final problemDescriptionController = TextEditingController();
  final locationController = TextEditingController();
  final genderController = GenderSelectionController();
  DateTime? startDate;
  DateTime? endDate;
  int? selectedAreaId;
  String? selectedAreaName;

  final ValueNotifier<bool> _isScheduled = ValueNotifier<bool>(false);

  List<dynamic> services = [];
  List<int> selectedServiceIds = [];

  final _requestCubit = RequestCubit();
  final _servicesCubit = ServicesCubit();
  final _areasCubit = AreasCubit();

  final _formKey = GlobalKey<FormState>();

  void setCompleteNumber(String number) {
    setState(() {
      completeNumber = number;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    locationController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _servicesCubit.fetchServices();
    _areasCubit.getAreas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        widget.setValue(null);
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      widget.setValue(null);
                    },
                  ),
                  Text(
                    widget.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              // MySecondButton(
              //   onTap: () {
              //     widget.setValue('home');
              //   },
              //   buttonText: 'Make an Appointment',
              //   icon: const Icon(
              //     Icons.arrow_back,
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Text(
                  context.localizations.pleaseFillTheBelowForm,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: LabeledTextfield(
                      padding: currentLocale.languageCode == 'ar'
                          ? const EdgeInsets.only(
                              right: 40,
                            )
                          : const EdgeInsets.only(
                              left: 40,
                            ),
                      label: context.localizations.firstName,
                      keyboardType: TextInputType.name,
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name.';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: LabeledTextfield(
                      padding: currentLocale.languageCode == 'ar'
                          ? const EdgeInsets.only(
                              left: 40,
                            )
                          : const EdgeInsets.only(
                              right: 40,
                            ),
                      label: context.localizations.lastName,
                      keyboardType: TextInputType.name,
                      controller: lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name.';
                        }

                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 7),
              PhoneNumberField(
                setCompleteNumber: setCompleteNumber,
              ),
              const SizedBox(height: 7),
              LabeledTextfield(
                expand: true,
                label: context.localizations.describeYourProblem,
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
                label: context.localizations.address,
                keyboardType: TextInputType.text,
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<AreasCubit, AreasState>(
                bloc: _areasCubit,
                builder: (context, state) {
                  if (state is GetAreasLoading) {
                    return const Loader();
                  }

                  if (state is GetAreasFailure) {
                    return Text(
                      'Failed to load areas: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  if (state is GetAreasSuccess) {
                    final areas = state.areas.areas;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.localizations.area,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 3),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Color(0xFFE7E7E7)),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Color(0xFFE7E7E7)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Color(0xFFE7E7E7)),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              fillColor: const Color(0xFFE7E7E7),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                            items: areas.map((area) {
                              return DropdownMenuItem<int>(
                                value: area.id,
                                child: Text(area.name.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAreaId = value;
                                selectedAreaName = areas[areas.indexWhere(
                                  (element) => element.id == value,
                                )]
                                    .name
                                    .toString();
                              });

                              if (selectedAreaId != null) {
                                _servicesCubit.fetchServicesFromArea(
                                  areaId: selectedAreaId!,
                                );
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an area';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(
                    child: Text(
                      'No areas available',
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              GenderSelectionField(controller: genderController),
              // const SizedBox(height: 7),
              // TimeTypeSelectionField(controller: timeTypeController),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  context.localizations.selectServices,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: BlocBuilder<ServicesCubit, ServicesState>(
                  bloc: _servicesCubit,
                  builder: (context, state) {
                    if (selectedAreaId == null) {
                      return const Text('Select an area to view services');
                    }

                    if (state is ServicesFetchFromAreaLoading) {
                      return const Loader();
                    } else if (state is ServicesFetchFromAreaSuccess) {
                      final services = state.services;

                      return ServicesList(
                        services: GetServicesModel(
                          services: services.services.map(
                            (e) {
                              return Service(
                                id: e.id,
                                name: e.name,
                                description: e.description,
                                price: e.price.toString(),
                                discountPrice: e.discountPrice.toString(),
                                servicePic: e.servicePic,
                                categoryId: e.categoryId,
                                createdAt: e.createdAt,
                                updatedAt: e.updatedAt,
                              );
                            },
                          ).toList(),
                        ),
                        selectedServiceIds: selectedServiceIds,
                      );
                    } else {
                      return const Text('Failed to fetch services.');
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localizations.scheduleAppointment,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: _isScheduled,
                        builder: (context, isScheduled, child) {
                          return Switch(
                            value: isScheduled,
                            onChanged: (value) {
                              _isScheduled.value = value;
                              // if (value) {
                              //   startDate = DateTime.now();
                              //   endDate = DateTime.now();
                              // }
                            },
                            activeTrackColor: const Color(0xFF4CAF50),
                            activeColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFBDBDBD),
                            inactiveThumbColor: Colors.white,
                          );
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: _isScheduled,
                builder: (context, value, child) {
                  if (value) {
                    return Padding(
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
                                currentDate: startDate ?? DateTime.now(),
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
                                currentDate: endDate ?? DateTime.now(),
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
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
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

                      if (selectedAreaId == null) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please select an area.',
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

                      if (selectedServiceIds.isEmpty) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please select at least one service.',
                        );
                        return;
                      }

                      if (_isScheduled.value == true &&
                          (startDate == null || endDate == null)) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'Please enter a date for the scheduled appointment.',
                        );
                        return;
                      } else if (startDate != null &&
                          startDate!.isAfter(endDate!)) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          'End date should be after start date.',
                        );
                        return;
                      }

                      _requestCubit.createRequest(
                        name: widget.category,
                        fullName:
                            '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
                        phoneNumber: completeNumber,
                        location: locationController.text.trim(),
                        problemDescription:
                            problemDescriptionController.text.trim(),
                        nurseGender: genderController.getGender()!,
                        selectedServices: selectedServiceIds,
                        startDate: _isScheduled.value ? startDate : null,
                        endDate: _isScheduled.value ? endDate : null,
                        areaId: selectedAreaId!,
                      );
                    },
                    buttonText: context.localizations.submit,
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
