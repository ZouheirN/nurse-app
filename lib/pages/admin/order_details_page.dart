import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_mini_textfield_order.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/main.dart';

import '../../utilities/helper_functions.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _problemDescriptionController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nurseGenderController = TextEditingController();
  final TextEditingController _timeTypeController = TextEditingController();

  final _requestCubit = RequestCubit();

  @override
  void initState() {
    super.initState();
    _requestCubit.getOrder(orderId: widget.orderId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _problemDescriptionController.dispose();
    _locationController.dispose();
    _nurseGenderController.dispose();
    _timeTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminHeader(title: 'Order #${widget.orderId}'),
      body: SingleChildScrollView(
        child: BlocConsumer<RequestCubit, RequestState>(
          bloc: _requestCubit,
          listener: (context, state) {
            if (state is RequestDetailsSuccess) {
              final request = state.request;

              _nameController.text = request.fullName ?? '';
              _phoneController.text = request.phoneNumber ?? '';
              _problemDescriptionController.text =
                  request.problemDescription ?? '';
              _locationController.text = request.location ?? '';
              _nurseGenderController.text = request.nurseGender ?? '';
              _timeTypeController.text = request.timeType ?? '';
            }
          },
          builder: (context, state) {
            if (state is RequestDetailsLoading) {
              return const Loader();
            }

            if (state is RequestDetailsSuccess) {
              final request = state.request;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        LabeledTextfield(
                          enabled: false,
                          controller: _nameController,
                          label: 'Full Name',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 10),
                        LabeledTextfield(
                          enabled: false,
                          controller: _phoneController,
                          label: 'Phone Number',
                        ),
                        const SizedBox(height: 10),
                        LabeledTextfield(
                          enabled: false,
                          controller: _problemDescriptionController,
                          label: 'Describe your problem',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 10),
                        LabeledTextfield(
                          enabled: false,
                          controller: _locationController,
                          label: 'Address',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: LabeledTextfield(
                                enabled: false,
                                controller: _nurseGenderController,
                                label: 'Nurse Gender',
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Flexible(
                              child: LabeledTextfield(
                                enabled: false,
                                controller: _timeTypeController,
                                label: 'Time Type',
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Services",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (int i = 0; i < request.services!.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 9,
                                  child: LabeledMiniTextfieldOrder(
                                    label: '',
                                    hintText: request.services![i].name,
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: LabeledMiniTextfieldOrder(
                                    textAlign: TextAlign.center,
                                    label: '',
                                    hintText:
                                        '\$${request.services![i].discountPrice == null ? formatPrice(num.parse(request.services![i].price!)) : formatPrice(num.parse(request.services![i].discountPrice!))}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (request.status == 'pending')
                          MyThirdButton(
                            onTap: () {
                              Navigator.pushNamed(context, '/submitOrder',
                                  arguments: request);
                            },
                            buttonText: 'Accept',
                          )
                        else if (request.status == 'approved')
                          MyThirdButton(
                            color: const Color(0xFF8D8D8D),
                            onTap: () {},
                            buttonText: 'Approved',
                          )
                        else if (request.status == 'completed')
                          Column(
                            children: [
                              MyThirdButton(
                                color: const Color(0xFF8D8D8D),
                                onTap: () {},
                                buttonText: 'Completed',
                              ),
                              const SizedBox(height: 10),
                              MyThirdButton(
                                color: Colors.red,
                                onTap: () {
                                  // todo
                                },
                                buttonText: 'Delete',
                              ),
                            ],
                          )
                        else if (request.status == 'canceled')
                          Column(
                            children: [
                              MyThirdButton(
                                color: Colors.red,
                                onTap: () {},
                                buttonText: 'Canceled',
                              ),
                              const SizedBox(height: 10),
                              MyThirdButton(
                                color: Colors.red,
                                onTap: () {
                                  // todo
                                },
                                buttonText: 'Delete',
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Text('Failed to load order details');
          },
        ),
      ),
    );
  }
}
