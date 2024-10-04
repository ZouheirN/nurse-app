import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/pages/user/immediate_request_page.dart';
import 'package:nurse_app/pages/user/pending_page.dart';

import 'make_appointment_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<String> _selectedOption = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.25,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    pauseAutoPlayOnTouch: true,
                    autoPlayInterval: const Duration(seconds: 5),
                  ),
                  items: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/image1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Text(
                            'Request your Nurse Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/image2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Text(
                            'Request your Nurse Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: _selectedOption,
                builder: (context, value, child) {
                  if (value == 'immediate') {
                    return ImmediateRequestPage(
                      setValue: (value) {
                        _selectedOption.value = value;
                      },
                    );
                  } else if (value == 'appointment') {
                    return MakeAppointmentPage(
                      setValue: (value) {
                        _selectedOption.value = value;
                      },
                    );
                  } else if (value == 'success') {
                    return PendingPage(
                      setValue: (value) {
                        _selectedOption.value = value;
                      },
                    );
                  }

                  return Column(
                    children: [
                      MySecondButton(
                        onTap: () {
                          _selectedOption.value = 'immediate';
                        },
                        buttonText: 'Immediate Request',
                      ),
                      const SizedBox(height: 15),
                      MySecondButton(
                        onTap: () {
                          _selectedOption.value = 'appointment';
                        },
                        buttonText: 'Make an Appointment',
                      ),
                      const SizedBox(height: 50),
                      const Center(
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 150,
                          width: 300,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
