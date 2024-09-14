import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/labeled_mini_textfield_admin.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/consts.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  String? selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    super.dispose();
  }

  void createService(String serviceName, double price, double discountPrice,
      String? image, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(KEY_ACCESS_TOKEN);

      final response = await http.post(
        Uri.parse('$HOST/admin/services'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': serviceName,
          'price': price,
          'discount_price': discountPrice,
          'image': image,
        }),
      );

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
                    onImageSelected: (image) {
                      setState(() {
                        selectedImage = image?.path;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {
                      final double price =
                          double.tryParse(priceController.text) ?? 0.0;
                      final double discountPrice =
                          double.tryParse(discountPriceController.text) ?? 0.0;
                      createService(
                        nameController.text,
                        price,
                        discountPrice,
                        selectedImage,
                        context,
                      );
                    },
                    buttonText: 'Add Service',
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
