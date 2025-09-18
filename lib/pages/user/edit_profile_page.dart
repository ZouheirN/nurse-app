import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/phone_number.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/profile/cubit/profile_cubit.dart';
import 'package:nurse_app/utilities/helper_functions.dart';
import 'package:quickalert/quickalert.dart';

import '../../services/user.dart';
import '../../services/user_token.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  String completeNumber = '';

  final _profileCubit = ProfileCubit();
  final _profileCubitBtn = ProfileCubit();

  @override
  void initState() {
    super.initState();
    _profileCubit.getProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 253, 233, 1.0),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.chevron_left, size: 48, color: Colors.white),
        ),
        title: Text(
          context.localizations.profile,
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
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: _profileCubit,
          listener: (context, state) {
            if (state is GetProfileSuccess) {
              final profile = state.profile;

              nameController.text = profile.name ?? '';

              if (profile.phoneNumber != null) {
                final number = PhoneNumber.fromCompleteNumber(
                    completeNumber: profile.phoneNumber!);
                phoneController.text = number.number;
              } else {
                phoneController.text = '';
              }
              emailController.text = profile.email ?? '';
              locationController.text = profile.location ?? '';
              birthDateController.text = formatDateYYYYMMDD(profile.birthDate) ?? '';
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoading) {
              return const Loader();
            } else if (state is GetProfileFailure) {
              return Center(
                child: Text(
                  state.message,
                ),
              );
            } else if (state is GetProfileSuccess) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              LabeledEditTextfield(
                                label: "Name", // todo localize
                                keyboardType: TextInputType.name,
                                controller: nameController,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  showCustomDatePicker(
                                      context, birthDateController);
                                },
                                child: LabeledEditTextfield(
                                  label: context.localizations.dateOfBirth,
                                  keyboardType: TextInputType.name,
                                  controller: birthDateController,
                                  enabled: false,
                                ),
                              ),
                              const SizedBox(height: 10),
                              LabeledEditTextfield(
                                label: context.localizations.location,
                                keyboardType: TextInputType.name,
                                controller: locationController,
                              ),
                              const SizedBox(height: 10),
                              LabeledEditTextfield(
                                label: context.localizations.emailAddress,
                                keyboardType: TextInputType.name,
                                controller: emailController,
                              ),
                              const SizedBox(height: 10),
                              PhoneNumberField(
                                controller: phoneController,
                                padding: EdgeInsets.zero,
                                fillColor: const Color(0xFFC2C2C2),
                                outlineColor: const Color(0xFFC2C2C2),
                                focusedColor:
                                    const Color.fromARGB(255, 185, 185, 185),
                                setCompleteNumber: (number) {
                                  completeNumber = number;
                                },
                              ),
                              const SizedBox(height: 22),
                              _buildSaveButton(),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   elevation: 0,
                      //   color: const Color.fromRGBO(255, 255, 255, 1),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(18.0),
                      //     child: Column(
                      //       children: [],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child: const ListTile(
                          title: Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          leading: Icon(
                            Icons.lock_outline,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child: ListTile(
                          onTap: () {
                            logoutUser();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          title: const Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          leading: const Icon(
                            Icons.logout,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text('An unexpected error occurred. '),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: _profileCubitBtn,
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
          _profileCubit.getProfile();
        } else if (state is UpdateProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateProfileLoading;

        return MyThirdButton(
          margin: EdgeInsets.zero,
          isLoading: isLoading,
          onTap: () {
            _profileCubitBtn.updateProfile(
              id: UserBox.getUser()!.id!,
              name: nameController.text.trim().isEmpty
                  ? null
                  : nameController.text.trim(),
              birthDate: birthDateController.text.trim().isEmpty
                  ? null
                  : birthDateController.text.trim(),
              location: locationController.text.trim().isEmpty
                  ? null
                  : locationController.text.trim(),
              phoneNumber: completeNumber.isEmpty ? null : completeNumber,
              email: emailController.text.trim().isEmpty
                  ? null
                  : emailController.text.trim(),
            );
          },
          buttonText: context.localizations.save,
        );
      },
    );
  }
}
