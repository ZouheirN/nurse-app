import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';

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
    _requestCubit.getRequestsHistory();
  }

  Future<void> _handleRefresh() async {
    await _requestCubit.getRequestsHistory();
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
              child: BlocBuilder<RequestCubit, RequestState>(
                bloc: _requestCubit,
                builder: (context, state) {
                  if (state is RequestsHistoryLoading) {
                    return const Loader();
                  }
                  if (state is RequestsHistorySuccess) {
                    final requests = state.requests;

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        // OrderCard(
                        //   title: '#1 From Client Name',
                        //   description: 'Check out the details',
                        //   time: '12:00',
                        //   onTap: () {
                        //     Navigator.pushNamed(context, '/orderDetails', arguments: 1);
                        //   },
                        // ),
                        // const SizedBox(height: 10),
                        // Column(
                        //   children: requests.map((request) {
                        //     return Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(vertical: 5),
                        //       child: OrderCard(
                        //         title: request['name'],
                        //         description: 'Check out the details',
                        //         time: request['created_at'],
                        //         onTap: () {
                        //           Navigator.pushNamed(
                        //             context,
                        //             '/orderDetails',
                        //             arguments: request['id'],
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),
                      ],
                    );
                  }

                  return const Text('Failed to load orders');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
