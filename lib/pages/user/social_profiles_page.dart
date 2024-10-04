import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/social_media_button.dart';
import 'package:nurse_app/features/about_us/cubit/about_us_cubit.dart';

class SocialProfilesPage extends StatelessWidget {
  SocialProfilesPage({super.key});

  final _aboutUsCubit = AboutUsCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            BlocBuilder<AboutUsCubit, AboutUsState>(
              bloc: _aboutUsCubit..fetchAboutUs(),
              builder: (context, state) {
                if (state is AboutUsFetchLoading) {
                  return const Expanded(child: Loader());
                }

                if (state is AboutUsFetchSuccess) {
                  final aboutUs = state.aboutUs;

                  return Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
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
                                    image: AssetImage(
                                        'assets/images/image2.png'),
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
                        Center(
                          child: SocialMediaButton(
                            accountName: 'www.alahmadnursingcare.com',
                            url: aboutUs['online_shop_url'],
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
                        Center(
                          child: SocialMediaButton(
                            logoPath: 'assets/images/instagram.png',
                            accountName: 'al_ahmad_nursing_care',
                            url: aboutUs['instagram_url'],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SocialMediaButton(
                            logoPath: 'assets/images/facebook.png',
                            accountName: 'Al Ahmad Nursing Care',
                            url: aboutUs['facebook_url'],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SocialMediaButton(
                            logoPath: 'assets/images/whatsapp.png',
                            accountName: aboutUs['whatsapp_number'],
                            url:
                            'https://wa.me/${aboutUs['whatsapp_number']}',
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }

                return const Text('Failed to fetch about us.');
              },
            ),
          ],
        ),
      ),
    );
  }
}
