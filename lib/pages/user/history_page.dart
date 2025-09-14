import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/filter_button.dart';
import 'package:nurse_app/components/header.dart';
import 'package:nurse_app/components/history_card.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/request/cubit/request_cubit.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _requestCubit = RequestCubit();

  late List<String> _filterOptions;
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _requestCubit.getRequestsHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterOptions = [
      context.localizations.today,
      context.localizations.thisWeek,
      context.localizations.lastMonth,
      context.localizations.all,
    ];
    _selectedFilter = context.localizations.all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 253, 233),
      appBar: AppBar(
        title: Text(
          context.localizations.requestHistory,
          style: const TextStyle(
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
      body: Column(
        children: [
          // const Center(
          //   child: Text(
          //     'Request History',
          //     style: TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.w700,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final filter in _filterOptions)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FilterButton(
                      filterText: filter,
                      isSelected: _selectedFilter == filter,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          BlocBuilder<RequestCubit, RequestState>(
            bloc: _requestCubit,
            builder: (context, state) {
              if (state is RequestsHistoryLoading) {
                return const Expanded(child: Loader());
              }

              if (state is RequestsHistoryFailure) {
                return Center(
                  child: Text(
                    state.message,
                  ),
                );
              }

              if (state is RequestsHistorySuccess) {
                final requests = state.requests.reversed.toList();

                // return HistoryCard(
                //   services: [
                //     Service(
                //       name: 'Basic Nursing Service',
                //       price: '15',
                //       id: 1,
                //       categoryId: 1,
                //       createdAt: DateTime.now(),
                //       description: 'Basic Nursing Service',
                //     )
                //   ],
                //   description: 'Check out the details',
                //   time: formatDateTimeForCard(DateTime.now()),
                //   onTap: () {},
                // );

                // Filter requests based on the selected filter
                List<dynamic> filteredRequests;
                final now = DateTime.now();
                if (_selectedFilter == context.localizations.today) {
                  filteredRequests = requests.where((request) {
                    return request.createdAt!.year == now.year &&
                        request.createdAt!.month == now.month &&
                        request.createdAt!.day == now.day;
                  }).toList();
                } else if (_selectedFilter == context.localizations.thisWeek) {
                  filteredRequests = requests.where((request) {
                    final weekAgo = now.subtract(const Duration(days: 7));
                    return request.createdAt!.isAfter(weekAgo);
                  }).toList();
                } else if (_selectedFilter == context.localizations.lastMonth) {
                  filteredRequests = requests.where((request) {
                    final monthAgo = DateTime(now.year, now.month - 1, now.day);
                    return request.createdAt!.isAfter(monthAgo);
                  }).toList();
                } else {
                  filteredRequests = requests;
                }

                if (filteredRequests.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(context.localizations.noRequestsFound),
                    ),
                  );
                }

                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: filteredRequests.map(
                      (request) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HistoryCard(
                            request: request,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/requestDetails',
                                arguments: request.id,
                              );
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              }

              return const Center(child: Text('Failed to load history.'));
            },
          ),
        ],
      ),
    );
  }
}
