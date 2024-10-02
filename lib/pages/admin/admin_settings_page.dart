import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/about_us/cubit/about_us_cubit.dart';
import 'package:nurse_app/utilities/dialogs.dart';

import '../../components/loader.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final websiteTextController = TextEditingController();
  final instagramTextController = TextEditingController();
  final facebookTextController = TextEditingController();
  final whatsappTextController = TextEditingController();

  final _aboutUsCubit = AboutUsCubit();
  final _aboutUsCubitButton = AboutUsCubit();

  @override
  void initState() {
    _aboutUsCubit.fetchAboutUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: BlocConsumer<AboutUsCubit, AboutUsState>(
                bloc: _aboutUsCubit,
                listener: (context, state) {
                  if (state is AboutUsFetchSuccess) {
                    final aboutUs = state.aboutUs;

                    websiteTextController.text = aboutUs['online_shop_url'];
                    instagramTextController.text = aboutUs['instagram_url'];
                    facebookTextController.text = aboutUs['facebook_url'];
                    whatsappTextController.text = aboutUs['whatsapp_number'];
                  }
                },
                builder: (context, state) {
                  if (state is AboutUsFetchLoading) {
                    return const Loader();
                  }

                  if (state is AboutUsFetchSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        LabeledTextfieldAdmin(
                          label: 'Website Link',
                          controller: websiteTextController,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 10),
                        LabeledTextfieldAdmin(
                          label: 'Instagram Link',
                          controller: instagramTextController,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 10),
                        LabeledTextfieldAdmin(
                          label: 'Facebook Link',
                          controller: facebookTextController,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 10),
                        LabeledTextfieldAdmin(
                          label: 'WhatsApp Link',
                          controller: whatsappTextController,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<AboutUsCubit, AboutUsState>(
                          bloc: _aboutUsCubitButton,
                          listener: (context, state) {
                            if (state is AboutUsUpdateSuccess) {
                              final aboutUs = state.aboutUs;

                              websiteTextController.text = aboutUs['online_shop_url'];
                              instagramTextController.text = aboutUs['instagram_url'];
                              facebookTextController.text = aboutUs['facebook_url'];
                              whatsappTextController.text = aboutUs['whatsapp_number'];

                              Dialogs.showSuccessDialog(context, 'Success',
                                  'About us updated successfully.');
                            } else if (state is AboutUsUpdateFailure) {
                              Dialogs.showErrorDialog(
                                  context, 'Error', state.message);
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is AboutUsUpdateLoading;

                            return MyThirdButton(
                              isLoading: isLoading,
                              onTap: () {
                                _aboutUsCubitButton.updateAboutUs(
                                  website: websiteTextController.text.trim(),
                                  instagram:
                                      instagramTextController.text.trim(),
                                  facebook: facebookTextController.text.trim(),
                                  whatsapp: whatsappTextController.text.trim(),
                                );
                              },
                              buttonText: 'Update',
                            );
                          },
                        ),
                      ],
                    );
                  }

                  return const Text('Failed to fetch about us.');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
