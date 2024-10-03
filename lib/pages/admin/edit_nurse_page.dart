import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/phone_field_admin.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';
import 'package:nurse_app/utilities/dialogs.dart';

class EditNursePage extends StatefulWidget {
  final int nurseId;

  const EditNursePage({super.key, required this.nurseId});

  @override
  State<EditNursePage> createState() => _EditNursePageState();
}

class _EditNursePageState extends State<EditNursePage> {
  String? profilePicture;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedImage;

  final _nurseCubit = NurseCubit();
  final _nurseCubitButton = NurseCubit();

  @override
  void initState() {
    super.initState();
    _nurseCubit.fetchNurse(widget.nurseId);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Edit Nurse'),
      body: BlocConsumer<NurseCubit, NurseState>(
        bloc: _nurseCubit,
        listener: (context, state) {
          if (state is NurseDetailsFetchSuccess) {
            final nurse = state.nurse.nurse!;

            nameController.text = nurse.name!;
            phoneController.text = nurse.phoneNumber!;
            addressController.text = nurse.address!;
            profilePicture = nurse.profilePicture;
          }
        },
        builder: (context, state) {
          if (state is NurseDetailsFetchLoading) {
            return const Loader();
          }

          if (state is NurseDetailsFetchSuccess) {
            return SingleChildScrollView(
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
                  PhoneFieldAdmin(
                    controller: phoneController,
                  ),
                  LabeledTextFieldAdmin(
                    label: 'Nurse Address',
                    keyboardType: TextInputType.text,
                    controller: addressController,
                  ),
                  const SizedBox(height: 20),
                  PickImage(
                    label: 'Nurse Picture',
                    initialImageUrl: profilePicture,
                    onImageSelected: (imageUrl) {
                      setState(() {
                        selectedImage = imageUrl;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<NurseCubit, NurseState>(
                    bloc: _nurseCubitButton,
                    listener: (context, state) {
                      if (state is NurseEditSuccess) {
                        Dialogs.showSuccessDialog(
                          context,
                          'Success',
                          'Nurse updated successfully',
                          onConfirmBtnTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/manageNurses', (route) => route.isFirst);
                          },
                        );
                      } else if (state is NurseEditFailure) {
                        Dialogs.showErrorDialog(
                          context,
                          'Error',
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is NurseEditLoading;

                      return MyThirdButton(
                        isLoading: isLoading,
                        onTap: () {
                          final name = nameController.text;
                          final phoneNumber = phoneController.text;
                          final address = addressController.text;

                          _nurseCubitButton.editNurse(
                            nurseId: widget.nurseId,
                            name: name,
                            phoneNumber: phoneNumber,
                            address: address,
                            selectedImage: selectedImage ?? profilePicture,
                          );
                        },
                        buttonText: 'Update Nurse',
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Error loading nurse details'),
          );
        },
      ),
    );
  }
}
