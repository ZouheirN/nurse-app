import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nurse_app/components/button.dart';
import 'package:nurse_app/components/logout_button.dart';
import 'package:nurse_app/components/profile_button.dart';
import 'package:nurse_app/components/second_button.dart';
import 'package:nurse_app/components/settings_button.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/l10n/l10n.dart';

import '../../services/user.dart';
import '../../streams/general_stream.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: const Color(0xFFFDFDFD),
      builder: (context) {
        return Container(
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
              const Text(
                'Need Support?',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'We\'re here to help you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              MySecondButton(
                onTap: () {},
                buttonText: 'Contact Us',
                icon: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: const Color(0xFFFDFDFD),
      builder: (context) {
        final currentLocale = Localizations.localeOf(context);

        return Container(
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
                context.localizations.changeLanguage,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                color: currentLocale.languageCode == 'ar'
                    ? const Color.fromRGBO(216, 253, 180, 1.0)
                    : null,
                child: ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 5,
                    color: currentLocale.languageCode == 'ar'
                        ? const Color.fromRGBO(122, 179, 65, 1.0)
                        : Colors.transparent,
                  ),
                  title: const Text(
                    'العربية',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    GeneralStream.languageStream.add(L10n.locals.firstWhere(
                      (locale) => locale.languageCode == 'ar',
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                color: currentLocale.languageCode == 'en'
                    ? const Color.fromRGBO(216, 253, 180, 1.0)
                    : null,
                child: ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 5,
                    color: currentLocale.languageCode == 'en'
                        ? const Color.fromRGBO(122, 179, 65, 1.0)
                        : Colors.transparent,
                  ),
                  title: const Text(
                    'English',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    GeneralStream.languageStream.add(L10n.locals.firstWhere(
                      (locale) => locale.languageCode == 'en',
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = UserBox.getUser();

    return Scaffold(
      backgroundColor: const Color(0xFFF3FDE9),
      appBar: AppBar(
        title: Text(
          user!.name.toString(),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage('assets/images/header_background.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 40),
                    // const Center(
                    //   child: Image(
                    //     image: AssetImage('assets/images/logo.png'),
                    //     height: 110,
                    //     width: 220,
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    // Center(
                    //   child: SettingsButton(
                    //     icon: const Icon(Icons.account_circle),
                    //     buttonText: 'Account Details',
                    //     onTap: () {
                    //       Navigator.pushNamed(context, '/editProfile');
                    //     },
                    //   ),
                    // ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ProfileButton(
                              iconImage: const AssetImage(
                                'assets/images/user2.png',
                              ),
                              buttonText: context.localizations.profile,
                              onTap: () {
                                Navigator.pushNamed(context, '/editProfile');
                              },
                            ),
                            ProfileButton(
                              iconImage: const AssetImage(
                                'assets/images/support.png',
                              ),
                              buttonText: context.localizations.support,
                              onTap: () {
                                _showSupportSheet(context);
                              },
                            ),
                            ProfileButton(
                              iconImage: const AssetImage(
                                'assets/images/language.png',
                              ),
                              buttonText: context.localizations.languageText,
                              onTap: () {
                                _showLanguageSheet(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Column(
                        children: [
                          const ListTile(
                            dense: true,
                            title: Text(
                              'Account Details',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/images/notification2.png',
                              height: 25,
                              width: 25,
                            ),
                            title: const Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/notifications', arguments: {
                                'showLeading': true,
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Divider(
                              color: Color.fromRGBO(120, 120, 120, 1),
                              height: 1,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/updateLocation');
                            },
                            leading: const Icon(Icons.location_on_outlined),
                            title: const Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Center(
                    //   child: SettingsButton(
                    //     icon: const Icon(Icons.location_on),
                    //     buttonText: 'Update Location',
                    //     onTap: () {
                    //       Navigator.pushNamed(context, '/updateLocation');
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 14),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Column(
                        children: [
                          const ListTile(
                            dense: true,
                            title: Text(
                              'Help Center',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/images/job.png',
                              height: 25,
                              width: 25,
                            ),
                            title: const Text(
                              'Apply for a Job',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 20,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Divider(
                              color: Color.fromRGBO(120, 120, 120, 1),
                              height: 1,
                            ),
                          ),
                          ExpansionTile(
                            iconColor: Colors.black,
                            collapsedIconColor: Colors.black,
                            leading: Image.asset(
                              'assets/images/faq.png',
                              height: 25,
                              width: 25,
                            ),
                            title: const Text(
                              'FAQs',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 24),
                    //   child: LogoutButton(
                    //     icon: const Icon(Icons.logout),
                    //     buttonText: 'Logout',
                    //     onTap: () {
                    //       logoutUser();
                    //       Navigator.pushNamedAndRemoveUntil(
                    //           context, '/login', (route) => false);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Center(
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.srcATop),
                    child: Image(
                      height: 80,
                      image: AssetImage(
                        'assets/images/square_logo.png',
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 30),
              //   child: Center(
              //     child: Column(
              //       children: [
              //         const Text(
              //           'Powered By',
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.w900),
              //         ),
              //         const SizedBox(height: 3),
              //         Image.asset(
              //           'assets/images/powered_by.png',
              //           width: 150,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
