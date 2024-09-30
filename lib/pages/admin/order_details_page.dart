import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_textfield.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/labeled_mini_textfield_order.dart';

import '../../services/user_token.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String location = '';

  bool isLoading = true;
  bool hasError = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> fetchOrderData() async {
    setState(() {
      isLoading = true;
    });

    final token = await UserToken.getToken();

    final response = await http.get(
      Uri.parse('$HOST/requests'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final orders = jsonData['orders'];

      final foundOrder = orders.firstWhere(
        (nurse) => nurse['id'] == widget.orderId,
        orElse: () => null,
      );

      if (foundOrder != null) {
        setState(() {
          name = jsonData['name'] ?? '';
          phoneNumber = jsonData['phone_number'] ?? '';
          email = jsonData['email'] ?? '';
          location = jsonData['location'] ?? '';

          nameController.text = name;
          phoneController.text = phoneNumber;
          emailController.text = email;
          locationController.text = location;

          isLoading = false;
        });
      } else {
        print('Failed to load user data');
      }
    }
  }

  Future<void> updateProfile() async {
    final token = await UserToken.getToken();

    final response = await http.put(
      Uri.parse('$HOST/requests/${widget.orderId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': nameController.text,
        'phone_number': phoneController.text,
        'email': emailController.text,
        'location': locationController.text,
      }),
    );

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Profile updated successfully.',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'];

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: errorMessage,
      );
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
                  const LabeledTextfield(
                    label: 'Full Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  PhoneNumberField(),
                  const LabeledTextfield(
                    label: 'Describe your problem',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  const LabeledTextfield(
                    label: 'Address',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 9,
                          child: LabeledMiniTextfieldOrder(
                            label: 'Service',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: LabeledMiniTextfieldOrder(
                            label: '',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/immediateOrder');
                    },
                    buttonText: 'Accept',
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
