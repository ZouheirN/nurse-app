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
    _selectedFilter = context.localizations.today;
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

                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: requests.map(
                      (request) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HistoryCard(
                            isOngoing: true,
                            services: request.services!,
                            description: 'Check out the details',
                            time: formatDateTimeForCard(request.createdAt!),
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
