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
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    pauseAutoPlayOnTouch: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    height: 180,
                    // viewportFraction: 0.8,
                    // enlargeFactor: 0.4,
                  ),
                  items: [
                    for (int i = 0; i <= 9; i++)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: AssetImage('assets/images/$i.png'),
                          fit: BoxFit.fitWidth,
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
