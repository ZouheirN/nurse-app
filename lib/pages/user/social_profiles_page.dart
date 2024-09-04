import 'package:flutter/material.dart';
import 'package:nurse_app/components/social_media_button.dart';

class SocialProfilesPage extends StatelessWidget {
  const SocialProfilesPage({super.key});

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 200,
                      width: 300,
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
                            'Check Our Social Profiles',
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
              const Center(
                child: Text(
                  'Check our website',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: SocialMediaButton(
                  accountName: 'www.alahmadnursingcare.com',
                  url: 'www.alahmadnursingcare.com',
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Check our Social Media profiles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: SocialMediaButton(
                  logoPath: 'assets/images/instagram.png',
                  accountName: 'al_ahmad_nursing_care',
                  url:
                      'https://www.instagram.com/al_ahmad_nursing_care?igsh=MW1hdDNwYTJ1amE1bQ==',
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: SocialMediaButton(
                  logoPath: 'assets/images/facebook.png',
                  accountName: 'Al Ahmad Nursing Care',
                  url: 'https://www.facebook.com/privatehomecarelb',
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: SocialMediaButton(
                  logoPath: 'assets/images/whatsapp.png',
                  accountName: '    +961 71 30 40 06     ',
                  url: 'https://wa.me/96171304006',
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
