import 'package:flutter/material.dart';
import 'package:nurse_app/components/star_rating.dart';
import 'package:nurse_app/components/text_data.dart';
import 'package:nurse_app/components/uneditable_labeled_date.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

class RequestDetailsPage extends StatelessWidget {
  final RequestsHistoryModel request;

  const RequestDetailsPage({super.key, required this.request});

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
            if (request.nurse != null && request.nurseId != null)
              _buildNurseDetails(request.nurseId),
            if (request.services != null)
              _buildServiceDetails(request.services!),
            StarRating(onRatingChanged: (rating) {}),
            const SizedBox(height: 10),
            _buildRequestDate(),
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

  Widget _buildNurseDetails(String nurseId) {
    // todo get nurse details from the server

    return Column(
      children: [
        Image.asset(
          'assets/images/dr.png',
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        const TextData(
          label: 'Nurse name: ',
          data: 'Nurse Name',
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildServiceDetails(List<Service> services) {
    return Column(
      children: services.map((service) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(
          //     color: const Color.fromARGB(255, 221, 221, 221),
          //     width: 1,
          //   ),
          // ),
          child: Column(
            children: [
              TextData(
                label: 'Service: ',
                data: service.name ?? '',
              ),
              const SizedBox(height: 10),
              TextData(
                label: 'Service Price: ',
                data: "\$${service.discountPrice ?? service.price}",
              ),
              const SizedBox(height: 10),
              const TextData(
                label: 'Time to get: ',
                data: '20 mins',
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRequestDate() {
    if (request.endingTime == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          'Request Date: ${formateDateTimeForRequestDetails(request.createdAt!)}',
          style: const TextStyle(
            fontSize: 22,
            color: Color(0xFF8E8E8E),
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return Padding(
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
                date: request.scheduledTime!,
              ),
              const SizedBox(height: 7),
              UneditableLabeledDate(
                label: 'End Date',
                date: request.endingTime!,
              ),
            ],
          ),
        ),
      );
    }
  }
}
