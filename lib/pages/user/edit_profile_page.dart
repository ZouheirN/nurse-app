import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/third_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';
import 'package:nurse_app/components/edit_phone_number_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List<Map<String, dynamic>> profile = [];
  String name = '';
  String phoneNumber = '';
  String email = '';
  String location = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.get(
      Uri.parse('$HOST/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        name = jsonData['name'] ?? '';
        phoneNumber = jsonData['phone_number'] ?? '';
        email = jsonData['email'] ?? '';
        location = jsonData['location'] ?? '';

        nameController.text = name;
        phoneController.text = phoneNumber;
        emailController.text = email;
        locationController.text = location;
      });
    } else {
      print('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  border: Border.all(
                    color: const Color(0xFFD9D9D9),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    LabeledEditTextfield(
                      label: 'Username',
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    const SizedBox(height: 7),
                    EditPhoneNumberField(controller: phoneController),
                    LabeledEditTextfield(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    const SizedBox(height: 7),
                    LabeledEditTextfield(
                      label: 'Location',
                      keyboardType: TextInputType.text,
                      controller: locationController,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MyThirdButton(
                onTap: () {},
                buttonText: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
