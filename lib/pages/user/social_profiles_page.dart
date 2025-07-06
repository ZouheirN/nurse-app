import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/social_media_button.dart';
import 'package:nurse_app/features/about_us/cubit/about_us_cubit.dart';
import 'package:nurse_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

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
            const Header(
              showLocation: false,
            ),
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
                        Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(19, 27, 10, 1),
                                Color.fromRGBO(101, 148, 54, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Reach Us At',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(16),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.stretch,
                        //     children: [
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(20),
                        //         child: Image.asset(
                        //           'assets/images/social.png',
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
                        const SizedBox(height: 15),
                        const Text(
                          'Office Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: FlutterMap(
                              options: const MapOptions(
                                initialCenter: latLng.LatLng(
                                    33.563520668688156, 35.389677252154485),
                                initialZoom: 15.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c'],
                                ),
                                // MarkerLayer(
                                //   markers: [
                                //     Marker(
                                //       point: LatLng(
                                //         aboutUs['location']['latitude'],
                                //         aboutUs['location']['longitude'],
                                //       ),
                                //       child: const Icon(
                                //         Icons.location_on,
                                //         color: Colors.red,
                                //         size: 40,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Our Socials',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
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
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 40,
                              ),
                              url: aboutUs['instagram_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                                size: 40,
                              ),
                              url: aboutUs['facebook_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.tiktok,
                                color: Colors.white,
                                size: 40,
                              ),
                              url: aboutUs['tiktok_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                                size: 40,
                              ),
                              url: aboutUs['tiktok_url'],
                              addPadding: false,
                            ),
                            SocialMediaButton(
                              icon: const Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                                size: 40,
                              ),
                              url: aboutUs['online_shop_url'],
                              addPadding: false,
                            ),
                          ],
                        ),
                        // const SizedBox(height: 15),
                        // const Center(
                        //   child: Text(
                        //     'Contact us',
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        // const SizedBox(height: 15),
                        // for (final number in aboutUs['whatsapp_numbers']) ...[
                        //   Center(
                        //     child: SocialMediaButton(
                        //       icon: const Icon(
                        //         FontAwesomeIcons.whatsapp,
                        //         color: Colors.white,
                        //         size: 30,
                        //       ),
                        //       url: 'https://wa.me/$number',
                        //       accountName: number,
                        //     ),
                        //   ),
                        //   const SizedBox(height: 10),
                        // ],
                        const SizedBox(height: 15),
                        const Text(
                          'Contact Form',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final privacyPolicyUrl = Uri.parse(
                                  'https://devzurapi.alahmadnursecare.com/privacy-policy');

                              launchUrl(privacyPolicyUrl);
                            },
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7BB442),
                              ),
                            ),
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

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, h * 0.5);
    path.quadraticBezierTo(w, h * 0.6, w, h * 0.5);
    path.quadraticBezierTo(w, h * 0.6, w, h * 0.5);
    path.lineTo(w, h * 0.5);
    path.lineTo(w, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
