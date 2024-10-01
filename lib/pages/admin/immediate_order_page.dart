import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:quickalert/quickalert.dart';

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

  @override
  void initState() {
    super.initState();
    fetchNurses();
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
    final services = widget.order.services;

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
                    const CircularProgressIndicator()
                  else
                    for (final service in services!)
                      Column(
                        children: [
                          LabeledDropdown(
                            label: 'Select Nurse',
                            services: nurses,
                          ),
                          const SizedBox(height: 10),
                          LabeledDropdown(
                            label: 'Select Service',
                            services: services.map(
                              (e) {
                                return service.toJson();
                              },
                            ).toList(),
                          ),
                          const Divider(
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      ),
                  // const SizedBox(height: 20),
                  const LabeledTextfield(
                    label: 'Time to arrive',
                    keyboardType: TextInputType.text,
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
