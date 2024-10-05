import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/social_media_button.dart';
import 'package:nurse_app/features/about_us/cubit/about_us_cubit.dart';
import 'package:nurse_app/main.dart';

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

                  logger.i(aboutUs);

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
                                    image:
                                        AssetImage('assets/images/image2.png'),
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
                        // const SizedBox(height: 10),
                        // const Center(
                        //   child: Text(
                        //     'Check our website',
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        // const SizedBox(height: 15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SocialMediaButton(
                              icon: const Icon(
                                Icons.language,
                                color: Colors.white,
                                size: 30,
                              ),
                              url: aboutUs['online_shop_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 30,
                              ),
                              url: aboutUs['instagram_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                                size: 30,
                              ),
                              url: aboutUs['facebook_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.tiktok,
                                color: Colors.white,
                                size: 30,
                              ),
                              url: aboutUs['tiktok_url'],
                              addPadding: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Center(
                          child: Text(
                            'Contact us',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 15),
                        for (final number in aboutUs['whatsapp_numbers']) ...[
                          Center(
                            child: SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                                size: 30,
                              ),
                              url: 'https://wa.me/$number',
                              accountName: number,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
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
