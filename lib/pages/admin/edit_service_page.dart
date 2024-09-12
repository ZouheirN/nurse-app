import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/labeled_mini_textfield_admin.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

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
          price = foundService['price'] ?? '';
          discountPrice = foundService['discount_price'] ?? '';
          image = foundService['service_pic'];

          nameController.text = name;
          priceController.text = price;
          discountPriceController.text = discountPrice!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Edit Service'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Error loading service details'))
              : SingleChildScrollView(
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
                                keyboardType: TextInputType.number,
                                controller: priceController,
                              ),
                            ),
                            Expanded(
                              child: LabeledMiniTextfieldAdmin(
                                label: 'Sale Price',
                                keyboardType: TextInputType.number,
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
                        onTap: () {},
                        buttonText: 'Update Service',
                      ),
                    ],
                  ),
                ),
    );
  }
}
