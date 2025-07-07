import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/phone_number.dart';
import 'package:nurse_app/components/labeled_edit_textfield.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/phone_number_field.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/consts.dart';
import 'package:quickalert/quickalert.dart';

import '../../services/user.dart';
import '../../services/user_token.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late int userId;
  bool isLoading = true;

  String name = '';
  String phoneNumber = '';
  String email = '';
  String location = '';
  String completeNumber = '';

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
    setState(() {
      isLoading = true;
    });

    final token = await UserToken.getToken();

    final response = await http.get(
      Uri.parse('$HOST/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        userId = jsonData['id'];
        name = jsonData['name'] ?? '';
        phoneNumber = jsonData['phone_number'] ?? '';
        email = jsonData['email'] ?? '';
        location = jsonData['location'] ?? '';

        nameController.text = name;
        phoneController.text = PhoneNumber.fromCompleteNumber(
                completeNumber: jsonData['phone_number'])
            .number;
        completeNumber = jsonData['phone_number'];
        emailController.text = email;
        locationController.text = location;

        isLoading = false;
      });
    } else {
      print('Failed to load user data');
    }
  }

  Future<void> updateProfile() async {
    final token = await UserToken.getToken();

    final response = await http.put(
      Uri.parse('$HOST/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': nameController.text,
        'phone_number': completeNumber,
        'email': emailController.text,
        'location': locationController.text,
      }),
    );

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Profile updated successfully.',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'];

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: errorMessage,
      );
    }
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
        title: const Text(
          'Profile',
          style: TextStyle(
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
        child: isLoading
            ? const Loader()
            : SingleChildScrollView(
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
                                label: 'First Name',
                                keyboardType: TextInputType.name,
                                controller: nameController,
                              ),
                              const SizedBox(height: 10),
                              LabeledEditTextfield(
                                label: 'Last Name',
                                keyboardType: TextInputType.name,
                                controller: nameController,
                              ),
                              const SizedBox(height: 10),
                              LabeledEditTextfield(
                                label: 'Nickname',
                                keyboardType: TextInputType.name,
                                controller: nameController,
                              ),
                              const SizedBox(height: 10),
                              LabeledEditTextfield(
                                label: 'Date of Birth',
                                keyboardType: TextInputType.name,
                                controller: nameController,
                              ),
                              const SizedBox(height: 22),
                              MyThirdButton(
                                margin: EdgeInsets.zero,
                                onTap: () {
                                  updateProfile();
                                },
                                buttonText: 'Save',
                              ),
                            ],
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
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              LabeledEditTextfield(
                                label: 'Email Address',
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
                              MyThirdButton(
                                margin: EdgeInsets.zero,
                                onTap: () {
                                  updateProfile();
                                },
                                buttonText: 'Save',
                              ),
                            ],
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
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFD9D9D9),
                      //     border: Border.all(
                      //       color: const Color(0xFFD9D9D9),
                      //       width: 2,
                      //     ),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       const SizedBox(height: 10),
                      //       LabeledEditTextfield(
                      //         label: 'Username',
                      //         keyboardType: TextInputType.name,
                      //         controller: nameController,
                      //       ),
                      //       const SizedBox(height: 7),
                      //       PhoneNumberField(
                      //         controller: phoneController,
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 20),
                      //         fillColor: const Color(0xFFC2C2C2),
                      //         outlineColor: const Color(0xFFC2C2C2),
                      //         focusedColor:
                      //             const Color.fromARGB(255, 185, 185, 185),
                      //         setCompleteNumber: (number) {
                      //           completeNumber = number;
                      //         },
                      //       ),
                      //       const SizedBox(height: 7),
                      //       LabeledEditTextfield(
                      //         label: 'Email',
                      //         keyboardType: TextInputType.emailAddress,
                      //         controller: emailController,
                      //       ),
                      //       const SizedBox(height: 7),
                      //       LabeledEditTextfield(
                      //         label: 'Location',
                      //         keyboardType: TextInputType.text,
                      //         controller: locationController,
                      //       ),
                      //       const SizedBox(height: 20),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // MyThirdButton(
                      //   onTap: () {
                      //     updateProfile();
                      //   },
                      //   buttonText: 'Save',
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
