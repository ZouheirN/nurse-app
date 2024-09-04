import 'package:flutter/material.dart';
import 'package:nurse_app/components/text_data.dart';
import 'package:nurse_app/components/uneditable_labeled_date.dart';

class ScheduledRequestDetailsPage extends StatelessWidget {
  const ScheduledRequestDetailsPage({super.key});

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

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(right: 110),
              child: Text(
                'Scheduled Date:',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF8E8E8E),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE7E7E7),
                  border: Border.all(
                    color: const Color(0xFFE7E7E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    UneditableLabeledDate(
                      label: 'Start Date',
                      date: DateTime.now(),
                    ),
                    const SizedBox(height: 7),
                    UneditableLabeledDate(
                      label: 'End Date',
                      date: DateTime.now(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
