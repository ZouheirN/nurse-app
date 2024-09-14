import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_dropdown.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImmediateOrderPage extends StatefulWidget {
  const ImmediateOrderPage({super.key});

  @override
  State<ImmediateOrderPage> createState() => _ImmediateOrderPageState();
}

class _ImmediateOrderPageState extends State<ImmediateOrderPage> {
  List<String> nurses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNurses();
  }

  Future<void> fetchNurses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.get(
      Uri.parse('$HOST/nurses'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        nurses = List<String>.from(
            data['nurses'].map((nurse) => nurse['name'].toString()));
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
                  LabeledDropdown(
                    label: 'Select Nurse',
                    services: nurses,
                  ),
                  const SizedBox(height: 20),
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
