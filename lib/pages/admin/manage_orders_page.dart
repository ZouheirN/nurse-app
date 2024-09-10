import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/order_card.dart';

class ManageOrdersPage extends StatelessWidget {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Orders'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  OrderCard(
                    title: '#1 From Client Name',
                    description: 'Check out the details',
                    time: '12:00',
                    onTap: () {
                      Navigator.pushNamed(context, '/orderDetails');
                    },
                  ),
                  const SizedBox(height: 10),
                  OrderCard(
                    title: '#2 From Client Name',
                    description: 'Check out the details',
                    time: '12:00',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  OrderCard(
                    title: '#3 From Client Name',
                    description: 'Check out the details',
                    time: '12:00',
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
