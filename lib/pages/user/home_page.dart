import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/pages/user/immediate_request_page.dart';
import 'package:nurse_app/pages/user/pending_page.dart';

import '../../components/faq.dart';
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
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpandableCarousel(
                      items: [
                        for (int i = 0; i <= 9; i++)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              image: AssetImage('assets/images/$i.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                      options: ExpandableCarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        pauseAutoPlayOnTouch: true,
                        showIndicator: false,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            const Faq(),
                            // const Center(
                            //   child: Image(
                            //     image: AssetImage('assets/images/logo.png'),
                            //     height: 150,
                            //     width: 300,
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
