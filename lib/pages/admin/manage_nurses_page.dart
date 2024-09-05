import 'package:flutter/material.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/nurse_card.dart';

class ManageNursesPage extends StatelessWidget {
  const ManageNursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Manage Nurses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  AdminCard(
                    imagePath: 'assets/images/image-gallery.png',
                    text: 'Add Nurse',
                    onTap: () {
                      Navigator.pushNamed(context, '/addNurse');
                    },
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nurses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  NurseCard(
                    imagePath: 'assets/images/dr.png',
                    title: 'John Doe',
                    onTap: () {
                      Navigator.pushNamed(context, '/editNurse');
                    },
                  ),
                  const SizedBox(height: 10),
                  NurseCard(
                    imagePath: 'assets/images/dr.png',
                    title: 'Jane Smith',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  NurseCard(
                    imagePath: 'assets/images/dr.png',
                    title: 'David Johnson',
                    onTap: () {},
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
