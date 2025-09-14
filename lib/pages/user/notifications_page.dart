import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    _selectedFilter = context.localizations.all;
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

                        List<dynamic> filteredNotifications;
                        final now = DateTime.now();
                        if (_selectedFilter == context.localizations.today) {
                          filteredNotifications =
                              notifications.where((notification) {
                            return notification.createdAt!.year == now.year &&
                                notification.createdAt!.month == now.month &&
                                notification.createdAt!.day == now.day;
                          }).toList();
                        } else if (_selectedFilter ==
                            context.localizations.thisWeek) {
                          filteredNotifications =
                              notifications.where((notification) {
                            final weekAgo =
                                now.subtract(const Duration(days: 7));
                            return notification.createdAt!.isAfter(weekAgo);
                          }).toList();
                        } else if (_selectedFilter ==
                            context.localizations.lastMonth) {
                          filteredNotifications =
                              notifications.where((notification) {
                            final monthAgo =
                                DateTime(now.year, now.month - 1, now.day);
                            return notification.createdAt!.isAfter(monthAgo);
                          }).toList();
                        } else {
                          filteredNotifications = notifications;
                        }

                        if (filteredNotifications.isEmpty) {
                          return Center(
                            child: Text(context.localizations.noRequestsFound),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];

                            return BlocProvider(
                              create: (context) => NotificationCubit(),
                              child: BlocListener<NotificationCubit,
                                  NotificationState>(
                                listener: (context, state) {
                                  if (state is MarkNotificationAsReadSuccess) {
                                    _notificationCubit
                                        .markNotificationAsReadFromList(
                                            notifications, notification.id!);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                      ),
                                    );
                                  } else if (state
                                      is DeleteNotificationSuccess) {
                                    _notificationCubit
                                        .deleteNotificationFromList(
                                            notifications, notification.id!);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Slidable(
                                    key: ValueKey(notification.id),
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      children: [
                                        if (notification.readAt == null)
                                          SlidableAction(
                                            onPressed: (context) {
                                              context
                                                  .read<NotificationCubit>()
                                                  .markNotificationAsRead(
                                                      notification.id!);
                                            },
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            icon: Icons.check,
                                            label: 'Mark as Read',
                                            padding: EdgeInsets.zero,
                                            flex: 2,
                                          ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            context
                                                .read<NotificationCubit>()
                                                .deleteNotification(
                                                    notification.id!);
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                    child: NotificationCard(
                                      title: notification.type != null &&
                                              notification.type!.isNotEmpty
                                          ? '${notification.type![0].toUpperCase()}${notification.type!.substring(1)}'
                                          : '',
                                      description:
                                          notification.message.toString(),
                                      time: notification.createdAt,
                                      isRead: notification.readAt != null,
                                    ),
                                  ),
                                ),
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
