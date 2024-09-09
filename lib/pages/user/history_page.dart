import 'package:flutter/material.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/history_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
              const Center(
                child: Text(
                  'Request History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: HistoryCard(
                  title: 'Critical Care: 20\$',
                  description: 'Check out the details',
                  time: '12:00',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: HistoryCard(
                  title: 'Home Visit: 100\$',
                  description: 'Check out the details',
                  time: '12:00',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: HistoryCard(
                  title: 'Rehabilitation Support: 30\$',
                  description: 'Check out the details',
                  time: '12:00',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
