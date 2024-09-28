import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:quickalert/quickalert.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/labeled_mini_textfield_admin.dart';

import '../../services/user_token.dart';

class EditServicePage extends StatefulWidget {
  final int serviceId;

  const EditServicePage({super.key, required this.serviceId});

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  String name = '';
  String price = '';
  String? discountPrice = '';
  String? image;

  bool isLoading = true;
  bool hasError = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchServiceData();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    super.dispose();
  }

  Future<void> fetchServiceData() async {
    final token = await UserToken.getToken();

    final response = await http.get(
      Uri.parse('$HOST/services'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final services = jsonData['services'];

      final foundService = services.firstWhere(
        (service) => service['id'] == widget.serviceId,
        orElse: () => null,
      );

      if (foundService != null) {
        setState(() {
          name = foundService['name'] ?? '';
          price = foundService['price'].toString();
          discountPrice = foundService['discount_price']?.toString();
          image = foundService['service_pic'];

          nameController.text = name;
          priceController.text = price;
          discountPriceController.text = discountPrice ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> updateService() async {
    final token = await UserToken.getToken();

    final double updatedPrice = double.tryParse(priceController.text) ?? 0.0;
    final String discountPriceText = discountPriceController.text;

    final Map<String, dynamic> requestBody = {
      'name': nameController.text,
      'price': updatedPrice,
      if (discountPriceText.isNotEmpty)
        'discount_price': double.tryParse(discountPriceText) ?? 0.0
      else
        'discount_price': null,
    };

    final response = await http.put(
      Uri.parse('$HOST/admin/services/${widget.serviceId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Service updated successfully.',
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
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return const Scaffold(
        body: Center(child: Text('Error loading service data')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Edit Service'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextfieldAdmin(
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
                    label: 'Nurse Picture',
                    onImageSelected: (image) {},
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: updateService,
                    buttonText: 'Update Service',
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
