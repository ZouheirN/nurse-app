import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/labeled_mini_textfield_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:nurse_app/consts.dart';

import '../../services/user_token.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  String? _serviceImageUrl;
  bool _isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Service name and price are required.',
      );
      return false;
    }
    return true;
  }

  void createService(String serviceName, double price, double discountPrice,
      String? imageUrl, BuildContext context) async {
    if (!_validateInputs()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = await UserToken.getToken();

      final Map<String, dynamic> requestBody = {
        'name': serviceName,
        'price': price,
        'service_pic': imageUrl ?? '',
      };

      if (discountPrice != 0) {
        requestBody['discount_price'] = discountPrice;
      }

      final response = await http.post(
        Uri.parse('$HOST/admin/services'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      setState(() {
        _isSubmitting = false;
      });

      if (response.statusCode == 201) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Service created successfully',
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
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
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
      appBar: const AdminHeader(title: 'Add New Service'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextFieldAdmin(
                    label: 'Service Name',
                    keyboardType: TextInputType.name,
                    controller: nameController,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      children: [
                        Expanded(
                          child: LabeledMiniTextfieldAdmin(
                            label: 'Service Price',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: priceController,
                          ),
                        ),
                        Expanded(
                          child: LabeledMiniTextfieldAdmin(
                            label: 'Sale Price',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: discountPriceController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  PickImage(
                    label: 'Service Picture',
                    onImageSelected: (imageUrl) {
                      setState(() {
                        _serviceImageUrl = imageUrl;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: _isSubmitting
                        ? null
                        : () {
                            final double price =
                                double.tryParse(priceController.text) ?? 0.0;
                            final double discountPrice =
                                double.tryParse(discountPriceController.text) ??
                                    0.0;

                            if (!_validateInputs()) return;

                            createService(
                              nameController.text,
                              price,
                              discountPrice,
                              _serviceImageUrl,
                              context,
                            );
                          },
                    buttonText: _isSubmitting ? 'Submitting...' : 'Add Service',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
