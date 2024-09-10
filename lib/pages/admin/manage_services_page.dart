import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/service_card_admin.dart';

class ManageServicesPage extends StatelessWidget {
  const ManageServicesPage({super.key});

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
                  ServiceCardAdmin(
                    title: 'Service Name',
                    price: '20\$',
                    onTap: () {
                      Navigator.pushNamed(context, '/editService');
                    },
                  ),
                  const SizedBox(height: 10),
                  ServiceCardAdmin(
                    title: 'Service Name',
                    price: '20\$',
                    salePrice: '15\$',
                    onTap: () {},
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
