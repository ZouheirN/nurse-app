import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/components/labeled_textfield_admin.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const LabeledTextfieldAdmin(
                    label: 'Website Link',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 10),
                  const LabeledTextfieldAdmin(
                    label: 'Instagram Link',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 10),
                  const LabeledTextfieldAdmin(
                    label: 'Facebook Link',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 10),
                  const LabeledTextfieldAdmin(
                    label: 'WhatsApp Link',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 20),
                  MyThirdButton(
                    onTap: () {},
                    buttonText: 'Update',
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
