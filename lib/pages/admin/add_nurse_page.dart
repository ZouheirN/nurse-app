import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/gender_selection_field_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/phone_field_admin.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';

import '../../utilities/dialogs.dart';

class AddNursePage extends StatefulWidget {
  const AddNursePage({super.key});

  @override
  State<AddNursePage> createState() => _AddNursePageState();
}

class _AddNursePageState extends State<AddNursePage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final genderController = GenderSelectionController();
  String? _profileImageUrl;

  final _nurseCubit = NurseCubit();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Add New Nurse'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextFieldAdmin(
                    label: 'Nurse Name',
                    keyboardType: TextInputType.name,
                    controller: nameController,
                  ),
                  const SizedBox(height: 10),
                  PhoneFieldAdmin(controller: phoneNumberController),
                  LabeledTextFieldAdmin(
                    label: 'Nurse Address',
                    keyboardType: TextInputType.text,
                    controller: addressController,
                  ),
                  const SizedBox(height: 10),
                  GenderSelectionFieldAdmin(controller: genderController),
                  const SizedBox(height: 20),
                  PickImage(
                    label: 'Nurse Picture',
                    onImageSelected: (imageUrl) {
                      setState(() {
                        _profileImageUrl = imageUrl;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<NurseCubit, NurseState>(
                    bloc: _nurseCubit,
                    listener: (context, state) {
                      if (state is NurseAddSuccess) {
                        Dialogs.showSuccessDialog(
                          context,
                          'Success',
                          'Nurse added successfully',
                          onConfirmBtnTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/manageNurses', (route) => route.isFirst);
                          },
                        );
                      } else if (state is NurseAddFailure) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is NurseAddLoading;

                      return MyThirdButton(
                        isLoading: isLoading,
                        onTap: () {
                          _nurseCubit.addNurse(
                            name: nameController.text,
                            phoneNumber: phoneNumberController.text,
                            address: addressController.text,
                            gender: genderController.getGender()!,
                            profilePicture: _profileImageUrl ?? '',
                          );
                        },
                        buttonText: 'Add Nurse',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
