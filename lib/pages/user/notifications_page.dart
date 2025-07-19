import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/notification/cubit/notification_cubit.dart';

import '../../components/filter_button.dart';
import '../../components/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  final bool showLeading;

  const NotificationsPage({super.key, required this.showLeading});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _notificationCubit = NotificationCubit();

  final bool show = true;

  late List<String> _filterOptions;
  late String _selectedFilter;

  @override
  void initState() {
    _notificationCubit.getNotifications();
    super.initState();
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
      appBar: AppBar(
        leading: widget.showLeading
            ? IconButton(
                icon: const Icon(Icons.chevron_left,
                    size: 48, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          context.localizations.notifications,
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
      backgroundColor: const Color.fromARGB(255, 243, 253, 233),
      body: !show
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/notification3.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'No Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
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
                Expanded(
                  child: BlocBuilder<NotificationCubit, NotificationState>(
                    bloc: _notificationCubit,
                    builder: (context, state) {
                      if (state is GetNotificationsLoading) {
                        return const Loader();
                      } else if (state is GetNotificationsFailure) {
                        return Center(
                          child: Text(
                            state.message,
                          ),
                        );
                      } else if (state is GetNotificationsSuccess) {
                        final notifications = state.notifications.notifications;
                        if (notifications.isEmpty) {
                          return const Center(
                            child: Text(
                              'No notifications available',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: NotificationCard(
                                title: notification.type,
                                description: '${notification.createdAt}',
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: Text('An unexpected error occurred'),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
