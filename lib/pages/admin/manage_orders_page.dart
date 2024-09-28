import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nurse_app/components/admin_header.dart';
import 'package:nurse_app/components/order_card.dart';
import 'package:nurse_app/main.dart';
import 'package:quickalert/quickalert.dart';

import '../../services/user_token.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });

    final token = await UserToken.getToken();

    final response = await http.get(
      Uri.parse('$HOST/admin/requests'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      logger.d(data);

      setState(() {
        requests = data['requests'];
        isLoading = false;
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to fetch orders.',
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Orders'),
      body: SafeArea(
        child: isLoading
            ? const Loader()
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        Column(
                          children: requests.map((request) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              child: OrderCard(
                                title: request['name'],
                                description: 'Check out the details',
                                time: request['created_at'],
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/orderDetails',
                                    arguments: request['id'],
                                  );
                                },
                              ),
                            );
                          }).toList(),
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
