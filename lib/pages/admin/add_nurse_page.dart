import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/phone_field_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/pick_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNursePage extends StatefulWidget {
  const AddNursePage({super.key});

  @override
  State<AddNursePage> createState() => _AddNursePageState();
}

class _AddNursePageState extends State<AddNursePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void createNurse(String name, String phoneNumber, String email,
      BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(KEY_ACCESS_TOKEN);

      final response = await http.post(
        Uri.parse('$HOST/admin/nurses'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': name,
          'phone_number': phoneNumber,
          'email': email,
        },
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Nurse Created'),
              content: const Text('Nurse created successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed create nurse'),
              content: const Text('Failed to create nurse. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'An error occurred. Please check your connection and try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
                  LabeledTextfieldAdmin(
                    label: 'Nurse Name',
                    keyboardType: TextInputType.name,
                    controller: nameController,
                  ),
                  const SizedBox(height: 10),
                  PhoneFieldAdmin(controller: phoneNumberController),
                  LabeledTextfieldAdmin(
                    label: 'Nurse Address',
                    keyboardType: TextInputType.text,
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  PickImage(
                    label: 'Nurse Picture',
                    onImageSelected: (image) {},
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {},
                    buttonText: 'Add Nurse',
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
