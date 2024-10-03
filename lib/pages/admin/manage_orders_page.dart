import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/order_card.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

import '../../components/loader.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  final _requestCubit = RequestCubit();

  @override
  initState() {
    super.initState();
    _requestCubit.getRequestsHistory(isAdmin: true);
  }

  Future<void> _handleRefresh() async {
    await _requestCubit.getRequestsHistory(isAdmin: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Orders'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  BlocBuilder<RequestCubit, RequestState>(
                    bloc: _requestCubit,
                    builder: (context, state) {
                      if (state is RequestsHistoryLoading) {
                        return const Loader();
                      }
                      if (state is RequestsHistorySuccess) {
                        final requests = state.requests.reversed.toList();

                        if (requests.isNotEmpty) {
                          return Column(
                            children: [
                              for (final request in requests)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: OrderCard(
                                    title: '#${request.id} From ${request.fullName}',
                                    time: formatDateTimeForCard(request.scheduledTime!),
                                    description: 'Check out the details',
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/orderDetails',
                                        arguments: request.id,
                                      );
                                    },
                                  ),
                                ),
                            ],
                          );
                        }
                      }

                      return const Text('Failed to load orders');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
