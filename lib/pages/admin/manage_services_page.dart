import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_card.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/service_card_admin.dart';
import 'package:nurse_app/features/services/cubit/services_cubit.dart';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  final _servicesCubit = ServicesCubit();

  @override
  void initState() {
    super.initState();
    _servicesCubit.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Manage Services'),
      body: SafeArea(
        child: BlocBuilder<ServicesCubit, ServicesState>(
          bloc: _servicesCubit,
          builder: (context, state) {
            if (state is ServicesFetchLoading) {
              return const Loader();
            }

            if (state is ServicesFetchSuccess) {
              final services = state.services;

              return RefreshIndicator(
                onRefresh: () {
                  return _servicesCubit.fetchServices();
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
                              text: 'Add Service',
                              onTap: () {
                                Navigator.pushNamed(context, '/addService');
                              },
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Services',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: services.map((service) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ServiceCardAdmin(
                                    imagePath: service['service_pic'] ??
                                        'assets/images/square_logo.png',
                                    title: service['name'],
                                    price: service['price'],
                                    salePrice: service['discount_price'],
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/editService',
                                        arguments: service['id'],
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
              child: Text('Failed to fetch services.'),
            );
          },
        ),
      ),
    );
  }
}
