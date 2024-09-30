import 'package:flutter/material.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/notification_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
