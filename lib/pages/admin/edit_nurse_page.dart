import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/pick_image.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nurse_app/components/phone_field_admin.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';

class EditNursePage extends StatefulWidget {
  final int nurseId;

  const EditNursePage({super.key, required this.nurseId});

  @override
  State<EditNursePage> createState() => _EditNursePageState();
}

class _EditNursePageState extends State<EditNursePage> {
  String name = '';
  String phoneNumber = '';
  String address = '';
  String? profilePicture;

  bool isLoading = true;
  bool hasError = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchNurseData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> fetchNurseData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.get(
      Uri.parse('$HOST/nurses'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final nurses = jsonData['nurses'];

      final foundNurse = nurses.firstWhere(
        (nurse) => nurse['id'] == widget.nurseId,
        orElse: () => null,
      );

      if (foundNurse != null) {
        setState(() {
          name = foundNurse['name'] ?? '';
          phoneNumber = foundNurse['phone_number'] ?? '';
          address = foundNurse['address'] ?? '';
          profilePicture = foundNurse['profile_picture'];

          nameController.text = name;
          phoneController.text = phoneNumber;
          addressController.text = address;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> updateNurse() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.put(
      Uri.parse('$HOST/admin/nurses/${widget.nurseId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': nameController.text,
        'phone_number': phoneController.text,
        'address': addressController.text,
        'profile_picture': selectedImage ?? profilePicture,
      }),
    );

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Nurse updated successfully',
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
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Edit Nurse'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Error loading nurse details'))
              : SingleChildScrollView(
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
                      PhoneFieldAdmin(
                        controller: phoneController,
                      ),
                      LabeledTextfieldAdmin(
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
                      MyThirdButton(
                        onTap: () {
                          updateNurse();
                        },
                        buttonText: 'Update Nurse',
                      ),
                    ],
                  ),
                ),
    );
  }
}
