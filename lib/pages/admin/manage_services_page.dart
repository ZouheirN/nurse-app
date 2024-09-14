import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/components/service_card_admin.dart';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.get(
      Uri.parse('$HOST/services'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        services = data['services'];
        isLoading = false;
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to fetch services.',
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
      appBar: const AdminHeader(title: 'Manage Services'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  AdminCard(
                    imagePath: 'assets/images/image-gallery.png',
                    text: 'Add Service',
                    onTap: () {
                      Navigator.pushNamed(context, '/addService');
                    },
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: services.map((service) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ServiceCardAdmin(
                                imagePath: 'assets/images/square_logo.png',
                                title: service['name'],
                                price: service['price'],
                                salePrice: service['discount_price'],
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/editService',
                                    arguments: service['id'],
                                  );
                                },
                              ),
                            );
                          }).toList(),
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
