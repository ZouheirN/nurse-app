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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _aboutUsCubit.fetchAboutUs();
    super.initState();
  }

  @override
  void dispose() {
    websiteTextController.dispose();
    instagramTextController.dispose();
    facebookTextController.dispose();
    whatsappTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Settings'),
      body: BlocConsumer<AboutUsCubit, AboutUsState>(
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          LabeledTextFieldAdmin(
                            label: 'Website Link',
                            controller: websiteTextController,
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Website link cannot be empty';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          LabeledTextFieldAdmin(
                            label: 'Instagram Link',
                            controller: instagramTextController,
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Instagram link cannot be empty';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          LabeledTextFieldAdmin(
                            label: 'Facebook Link',
                            controller: facebookTextController,
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Facebook link cannot be empty';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          LabeledTextFieldAdmin(
                            label: 'WhatsApp Link',
                            controller: whatsappTextController,
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'WhatsApp link cannot be empty';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<AboutUsCubit, AboutUsState>(
                            bloc: _aboutUsCubitButton,
                            listener: (context, state) {
                              if (state is AboutUsUpdateSuccess) {
                                final aboutUs = state.aboutUs;

                                websiteTextController.text =
                                    aboutUs['online_shop_url'];
                                instagramTextController.text =
                                    aboutUs['instagram_url'];
                                facebookTextController.text =
                                    aboutUs['facebook_url'];
                                whatsappTextController.text =
                                    aboutUs['whatsapp_number'];

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
                                  if (_formKey.currentState!.validate()) {
                                    _aboutUsCubitButton.updateAboutUs(
                                      website:
                                          websiteTextController.text.trim(),
                                      instagram:
                                          instagramTextController.text.trim(),
                                      facebook:
                                          facebookTextController.text.trim(),
                                      whatsapp:
                                          whatsappTextController.text.trim(),
                                    );
                                  }
                                },
                                buttonText: 'Update',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Failed to fetch about us.'));
        },
      ),
    );
  }
}
