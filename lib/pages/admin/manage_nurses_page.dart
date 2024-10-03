import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/nurse_card.dart';
import 'package:nurse_app/features/nurse/cubit/nurse_cubit.dart';

class ManageNursesPage extends StatefulWidget {
  const ManageNursesPage({super.key});

  @override
  State<ManageNursesPage> createState() => _ManageNursesPageState();
}

class _ManageNursesPageState extends State<ManageNursesPage> {
  final _nurseCubit = NurseCubit();

  @override
  void initState() {
    super.initState();
    _nurseCubit.fetchNurses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Manage Nurses'),
      body: SafeArea(
        child: BlocBuilder<NurseCubit, NurseState>(
          bloc: _nurseCubit,
          builder: (context, state) {
            if (state is NurseFetchLoading) {
              return const Loader();
            }

            if (state is NurseFetchSuccess) {
              final nurses = state.nurses.nurses!;

              return RefreshIndicator(
                onRefresh: () {
                  return _nurseCubit.fetchNurses();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                            Column(
                              children: nurses.map((nurse) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: NurseCard(
                                    imagePath: nurse.profilePicture ??
                                        'assets/images/default_profile.png',
                                    title: nurse.name!,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/editNurse',
                                        arguments: nurse.id!,
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

            return const Center(
              child: Text('Error loading nurses'),
            );
          },
        ),
      ),
    );
  }
}
