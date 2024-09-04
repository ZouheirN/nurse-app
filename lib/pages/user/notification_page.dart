import 'package:flutter/material.dart';
import 'package:nurse_app/components/notification_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
              const SizedBox(height: 15),
              Center(
                child: NotificationCard(
                  title: 'Your request was accepted',
                  description: 'Check out the details',
                  time: '12:00',
                  onTap: () {
                    Navigator.pushNamed(context, '/scheduledRequestDetails');
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: NotificationCard(
                  title: 'Your request was accepted',
                  description: 'Check out the details',
                  time: '12:00',
                  onTap: () {
                    Navigator.pushNamed(context, '/immediateRequestDetails');
                  },
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: NotificationCard(
                  title: 'Your request was accepted',
                  description: 'Check out the details',
                  time: '12:00',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: NotificationCard(
                  title: 'Your request was accepted',
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
