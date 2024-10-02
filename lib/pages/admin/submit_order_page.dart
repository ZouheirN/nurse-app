import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/features/services/cubit/services_cubit.dart';
import 'package:nurse_app/utilities/dialogs.dart';

import '../../components/service_card.dart';
import '../../components/uneditable_labeled_date.dart';

class SubmitOrderPage extends StatefulWidget {
  final RequestsHistoryModel order;

  const SubmitOrderPage({super.key, required this.order});

  @override
  State<SubmitOrderPage> createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends State<SubmitOrderPage> {
  List<num> selectedServiceIds = [];
  String? selectedNurseId;

  final _servicesCubit = ServicesCubit();
  final _nurseCubit = NurseCubit();
  final _requestCubit = RequestCubit();

  final TextEditingController _timeToArriveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _servicesCubit.fetchServices();
    _nurseCubit.fetchNurses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminHeader(title: 'Order #${widget.order.id}'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  BlocBuilder<NurseCubit, NurseState>(
                    bloc: _nurseCubit,
                    builder: (context, state) {
                      if (state is NurseFetchLoading) {
                        return const Loader();
                      }

                      if (state is NurseFetchSuccess) {
                        final filteredNurses = state.nurses;

                        final nurses = List<Map<String, String>>.from(
                          filteredNurses.nurses!.map(
                            (nurse) => {
                              'name': nurse.name.toString(),
                              'profile_picture':
                                  nurse.profilePicture.toString(),
                              'id': nurse.id.toString(),
                            },
                          ),
                        );

                        return Column(
                          children: [
                            LabeledDropdown(
                              label: 'Select Nurse',
                              leadingLabel:
                                  'Preferred Gender: ${widget.order.nurseGender}',
                              services: nurses,
                              onChanged: (value) {
                                selectedNurseId = value!['id'];
                              },
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child:
                                    BlocBuilder<ServicesCubit, ServicesState>(
                                  bloc: _servicesCubit,
                                  builder: (context, state) {
                                    if (state is ServicesFetchLoading) {
                                      return const SizedBox();
                                    } else if (state is ServicesFetchSuccess) {
                                      final services = state.services;

                                      selectedServiceIds = widget
                                          .order.services!
                                          .map((e) => e.id!)
                                          .toList();

                                      return Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: services.map((service) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ServiceCard(
                                              serviceId: service['id'],
                                              imagePath: service[
                                                      'service_pic'] ??
                                                  'assets/images/square_logo.png',
                                              title: service['name'],
                                              price: service['price'],
                                              salePrice:
                                                  service['discount_price'],
                                              isSelected: selectedServiceIds
                                                  .contains(service['id']),
                                              onSelectionChanged: (isSelected) {
                                                if (isSelected) {
                                                  selectedServiceIds
                                                      .add(service['id']);
                                                } else {
                                                  selectedServiceIds
                                                      .remove(service['id']);
                                                }
                                              },
                                              enableTap: true,
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    } else {
                                      return const Text(
                                          'Failed to fetch services.');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const Text('Failed to fetch nurses.');
                    },
                  ),
                  const SizedBox(height: 20),
                  if (widget.order.endingTime == null)
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: LabeledTextfield(
                            label: 'Time to arrive',
                            keyboardType: TextInputType.number,
                            controller: _timeToArriveController,
                            padding: const EdgeInsets.only(left: 40),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: LabeledTextfield(
                            label: '',
                            enabled: false,
                            hintText: 'min',
                            centerHintText: true,
                            padding: EdgeInsets.only(right: 40),
                          ),
                        ),
                      ],
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E7E7),
                          border: Border.all(
                            color: const Color(0xFFE7E7E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            UneditableLabeledDate(
                              label: 'Start Date',
                              date: widget.order.scheduledTime!,
                            ),
                            const SizedBox(height: 7),
                            UneditableLabeledDate(
                              label: 'End Date',
                              date: widget.order.endingTime!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  BlocConsumer<RequestCubit, RequestState>(
                    bloc: _requestCubit,
                    listener: (context, state) {
                      if (state is RequestSubmitSuccess) {
                        Dialogs.showSuccessDialog(
                          context,
                          'Request submitted successfully',
                          'The request is now approved.',
                          onConfirmBtnTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/adminDashboard', (route) => false);
                          },
                        );
                      } else if (state is RequestSubmitFailure) {
                        Dialogs.showErrorDialog(
                          context,
                          'Failed to submit request',
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is RequestSubmitLoading;

                      return MyThirdButton(
                        isLoading: isLoading,
                        onTap: () {
                          _requestCubit.submitRequest(
                            id: widget.order.id!,
                            status: 'approved',
                            scheduledTime: widget.order.scheduledTime!,
                            timeNeededToArrive: widget.order.endingTime != null
                                ? null
                                : int.parse(
                                    _timeToArriveController.text.trim()),
                            endingTime: widget.order.endingTime,
                            location: widget.order.location!,
                            nurseId: int.parse(selectedNurseId!),
                            serviceIds: selectedServiceIds,
                            timeType: widget.order.timeType!,
                            problemDescription: widget.order.problemDescription,
                            nurseGender: widget.order.nurseGender!,
                          );
                        },
                        buttonText: 'Submit',
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
