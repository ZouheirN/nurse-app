import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/features/services/cubit/services_cubit.dart';
import 'package:nurse_app/main.dart';
import 'package:quickalert/quickalert.dart';

import '../../components/service_card.dart';
import '../../services/user_token.dart';

class ImmediateOrderPage extends StatefulWidget {
  final RequestsHistoryModel order;

  const ImmediateOrderPage({super.key, required this.order});

  @override
  State<ImmediateOrderPage> createState() => _ImmediateOrderPageState();
}

class _ImmediateOrderPageState extends State<ImmediateOrderPage> {
  List<Map<String, String>> nurses = [];
  bool isLoading = true;

  List<num> selectedServiceIds = [];
  final _servicesCubit = ServicesCubit();

  String? selectedNurseId;

  final TextEditingController _timeToArriveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNurses();
    _servicesCubit.fetchServices();
  }

  Future<void> fetchNurses() async {
    final token = await UserToken.getToken();

    final response = await http.get(
      Uri.parse('$HOST/nurses'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        nurses = List<Map<String, String>>.from(
          data['nurses'].map((nurse) => {
                'name': nurse['name'].toString(),
                'profile_picture': nurse['profile_picture'].toString(),
                'id': nurse['id'].toString(),
              }),
        );
        isLoading = false;
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to fetch nurses.',
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
                  if (isLoading)
                    const Loader()
                  else
                    Column(
                      children: [
                        LabeledDropdown(
                          label: 'Select Nurse',
                          services: nurses,
                          onChanged: (value) {
                            selectedNurseId = value!['id'];
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: BlocBuilder<ServicesCubit, ServicesState>(
                              bloc: _servicesCubit,
                              builder: (context, state) {
                                if (state is ServicesFetchLoading) {
                                  return const SizedBox();
                                } else if (state is ServicesFetchSuccess) {
                                  final services = state.services;

                                  selectedServiceIds = widget.order.services!
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
                                          imagePath: service['service_pic'] ??
                                              'assets/images/square_logo.png',
                                          title: service['name'],
                                          price: service['price'],
                                          salePrice: service['discount_price'],
                                          isSelected: selectedServiceIds
                                              .contains(service['id']),
                                          onSelectionChanged: (isSelected) {},
                                          enableTap: false,
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
                    ),
                  const SizedBox(height: 20),
                  LabeledTextfield(
                    label: 'Time to arrive',
                    keyboardType: TextInputType.text,
                    controller: _timeToArriveController,
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/scheduledOrder');
                    },
                    buttonText: 'Submit',
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
