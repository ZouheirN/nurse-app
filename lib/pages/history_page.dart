import 'package:flutter/material.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: () {},
                      ),
                      const Text(
                        'Beirut, Lebanon',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF7BB442),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {},
                  ),
                  const Text(
                    'Welcome Back User',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
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
              const Center(
                child: HistoryCard(
                  title: 'Critical Care: 20\$',
                  description: 'Check out the details',
                  time: '12:00',
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: HistoryCard(
                  title: 'Home Visit: 100\$',
                  description: 'Check out the details',
                  time: '12:00',
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: HistoryCard(
                  title: 'Rehabilitation Support: 30\$',
                  description: 'Check out the details',
                  time: '12:00',
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
