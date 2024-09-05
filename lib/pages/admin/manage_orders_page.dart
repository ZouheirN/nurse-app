import 'package:flutter/material.dart';
import 'package:nurse_app/components/order_card.dart';

class ManageOrdersPage extends StatelessWidget {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
