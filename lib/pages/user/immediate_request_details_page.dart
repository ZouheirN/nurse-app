import 'package:flutter/material.dart';
import 'package:nurse_app/components/star_rating.dart';
import 'package:nurse_app/components/text_data.dart';

class ImmediateRequestDetailsPage extends StatelessWidget {
  const ImmediateRequestDetailsPage({super.key});

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
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Nurse Request',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Request Details:',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/dr.png',
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const TextData(
              label: 'Nurse name: ',
              data: 'Ahmad Al-Ali',
            ),
            const SizedBox(height: 10),
            const TextData(
              label: 'Service: ',
              data: 'Critical Care',
            ),
            const SizedBox(height: 10),
            const TextData(
              label: 'Service Price: ',
              data: '20\$',
            ),
            const SizedBox(height: 10),
            const TextData(
              label: 'Time to get: ',
              data: '20 mins',
            ),
            const SizedBox(height: 10),
            StarRating(onRatingChanged: (rating) {}),
            const SizedBox(height: 10),
            const TextData(
              label: 'Request Date: ',
              data: '8/25/2024 9:10 am',
            ),
            const SizedBox(height: 30),
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                height: 110,
                width: 220,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
