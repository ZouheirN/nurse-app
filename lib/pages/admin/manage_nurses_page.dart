import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/nurse_card.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageNursesPage extends StatefulWidget {
  const ManageNursesPage({super.key});

  @override
  State<ManageNursesPage> createState() => _ManageNursesPageState();
}

class _ManageNursesPageState extends State<ManageNursesPage> {
  List<dynamic> nurses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNurses();
  }

  Future<void> fetchNurses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEY_ACCESS_TOKEN);

    final response = await http.get(
      Uri.parse('$HOST/nurses'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        nurses = data['nurses'];
        isLoading = false;
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to fetch nurses.',
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Manage Nurses'),
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
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: nurses.map((nurse) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: NurseCard(
                                imagePath: 'assets/images/dr.png',
                                title: nurse['name'],
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/editNurse',
                                    arguments: nurse['id'],
                                  );
                                },
                              ),
                            );
                          }).toList(),
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
