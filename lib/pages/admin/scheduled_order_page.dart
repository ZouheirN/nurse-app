import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';
import 'package:nurse_app/components/uneditable_labeled_date.dart';
import 'package:quickalert/quickalert.dart';

import '../../services/user_token.dart';

class ScheduledOrderPage extends StatefulWidget {
  const ScheduledOrderPage({super.key});

  @override
  State<ScheduledOrderPage> createState() => _ScheduledOrderPageState();
}

class _ScheduledOrderPageState extends State<ScheduledOrderPage> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Order #1'),
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
                    LabeledDropdown(
                      label: 'Select Nurse',
                      services: nurses,
                    ),
                  // const SizedBox(height: 10),
                  // const LabeledDropdown(
                  //   label: 'Select Service',
                  //   services: [
                  //     'Service 1',
                  //     'Service 2',
                  //     'Service 3',
                  //     'Service 4',
                  //     'Service 5',
                  //     'Service 6',
                  //   ],
                  // ),
                  const SizedBox(height: 20),
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
                            date: DateTime.now(),
                          ),
                          const SizedBox(height: 7),
                          UneditableLabeledDate(
                            label: 'End Date',
                            date: DateTime.now(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const LabeledTextfield(
                    label: 'Time to arrive',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/orderProcess');
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
