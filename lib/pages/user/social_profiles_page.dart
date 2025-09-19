import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/social_media_button.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/about_us/cubit/about_us_cubit.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/labeled_edit_textfield.dart';
import '../../components/phone_number_field.dart';
import '../../components/second_button.dart';
import '../../components/third_button.dart';

class SocialProfilesPage extends StatelessWidget {
  SocialProfilesPage({super.key});

  final _aboutUsCubit = AboutUsCubit();

  void _showWhatsappNumbersSheet(BuildContext context, List<String> numbers) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: const Color(0xFFFDFDFD),
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5.0,
                  width: 50.0,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(142, 142, 142, 0.53),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.localizations.whatsAppNumbers,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                for (final number in numbers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MySecondButton(
                      onTap: () {
                        final whatsappUrl = Uri.parse('https://wa.me/$number');
                        launchUrl(whatsappUrl);
                      },
                      buttonText: number,
                      icon: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
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
                          child: Center(
                            child: Text(
                              context.localizations.reachUsAt,
                              style: const TextStyle(
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
                        Text(
                          context.localizations.officeLocation,
                          style: const TextStyle(
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
                                  userAgentPackageName: "com.devzur.alahmad",
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
                        Center(
                          child: Text(
                            context.localizations.ourSocials,
                            style: const TextStyle(
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
                            if (aboutUs['whatsapp_numbers'].length == 1)
                              SocialMediaButton(
                                icon: const Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                url: aboutUs['whatsapp_numbers'][0],
                                addPadding: false,
                              )
                            else
                              SocialMediaButton(
                                icon: const Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                urls: List<String>.from(
                                  aboutUs['whatsapp_numbers'],
                                ),
                                addPadding: false,
                                onTap: () => _showWhatsappNumbersSheet(
                                  context,
                                  List<String>.from(
                                      aboutUs['whatsapp_numbers']),
                                ),
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
                        Text(
                          context.localizations.contactForm,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        _buildContactFormButton(context),
                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final privacyPolicyUrl = Uri.parse(
                                  'https://devzurapi.alahmadnursecare.com/privacy-policy');

                              launchUrl(privacyPolicyUrl);
                            },
                            child: Text(
                              context.localizations.privacyPolicy,
                              style: const TextStyle(
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

  Widget _buildContactFormButton(BuildContext context) {
    final contactFormCubit = AboutUsCubit();

    final phoneController = TextEditingController();
    String completeNumber = '';
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final addressController = TextEditingController();
    final problemDescriptionController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: LabeledEditTextfield(
                  controller: firstNameController,
                  label: context.localizations.firstName,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LabeledEditTextfield(
                  controller: lastNameController,
                  label: context.localizations.lastName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PhoneNumberField(
            controller: phoneController,
            padding: EdgeInsets.zero,
            fillColor: const Color(0xFFC2C2C2),
            outlineColor: const Color(0xFFC2C2C2),
            focusedColor: const Color.fromARGB(255, 185, 185, 185),
            setCompleteNumber: (number) {
              completeNumber = number;
            },
          ),
          LabeledEditTextfield(
            controller: addressController,
            label: context.localizations.address,
          ),
          const SizedBox(height: 10),
          LabeledEditTextfield(
            controller: problemDescriptionController,
            label: context.localizations.describeYourProblem,
          ),
          const SizedBox(height: 10),
          BlocConsumer<AboutUsCubit, AboutUsState>(
            bloc: contactFormCubit,
            listener: (context, state) {
              if (state is SubmitContactFormFailure) {
                Dialogs.showErrorDialog(
                  context,
                  'Error',
                  state.message,
                );
              } else if (state is SubmitContactFormSuccess) {
                Dialogs.showSuccessDialog(
                  context,
                  'Success',
                  'Your message has been sent successfully.',
                );
                // Clear the form fields after successful submission
                firstNameController.clear();
                lastNameController.clear();
                phoneController.clear();
                addressController.clear();
                problemDescriptionController.clear();
              }
            },
            builder: (context, state) {
              final isLoading = state is SubmitContactFormLoading;

              return MyThirdButton(
                isLoading: isLoading,
                margin: EdgeInsets.zero,
                onTap: () {
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      completeNumber.isEmpty ||
                      addressController.text.isEmpty ||
                      problemDescriptionController.text.isEmpty) {
                    Dialogs.showErrorDialog(
                      context,
                      'Error',
                      'Please fill in all fields.',
                    );
                    return;
                  }

                  contactFormCubit.submitContactForm(
                    phoneNumber: completeNumber,
                    description: problemDescriptionController.text.trim(),
                    address: addressController.text.trim(),
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                  );
                },
                buttonText: context.localizations.submit,
              );
            },
          ),
        ],
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
