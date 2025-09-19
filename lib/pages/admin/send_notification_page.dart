import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/labeled_expandable_textfield_admin.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/components/textfield.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/notification/cubit/notification_cubit.dart';
import 'package:nurse_app/utilities/dialogs.dart';

import '../../components/admin_header.dart';
import '../../components/labeled_textfield_admin.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final _notificationCubit = NotificationCubit();

  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<String?> _selectedScreen = ValueNotifier<String?>(null);

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Notifications'),
      body: ValueListenableBuilder(
        valueListenable: _selectedScreen,
        builder: (context, value, child) {
          if (value == 'all_users') {
            return _buildAllUsersScreen();
          } else if (value == 'specific_user') {
            return _buildSpecificUserScreen();
          } else if (value == 'notifications_history') {
            return _buildNotificationsHistoryScreen();
          } else if (value != null &&
              value.startsWith('send_specific_notification')) {
            final parts = value.split('+');
            if (parts.length == 3) {
              final userId = parts[1];
              final userName = parts[2];
              return _buildSendSpecificNotification(
                userId: userId,
                userName: userName,
              );
            } else {
              return const Center(child: Text('Invalid user data'));
            }
          } else {
            return _buildSelectionScreen();
          }
        },
      ),
    );
  }

  Widget _buildSelectionScreen() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios),
          title: const Text('Send Notification to All Users'),
          onTap: () {
            _selectedScreen.value = 'all_users';
          },
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios),
          title: const Text('Send Notification to a Specific User'),
          onTap: () {
            _selectedScreen.value = 'specific_user';
          },
        ),
        ListTile(
          trailing: const Icon(Icons.arrow_forward_ios),
          title: const Text('Check Your Notifications History'),
          onTap: () {
            _selectedScreen.value = 'notifications_history';
          },
        ),
      ],
    );
  }

  Widget _buildAllUsersScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: const Text(
              'Send Notification to All Users',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _selectedScreen.value = null; // Go back to selection screen
              },
            ),
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextFieldAdmin(
                    label: 'Title',
                    keyboardType: TextInputType.name,
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  LabeledExpandableTextFieldAdmin(
                    label: 'Content',
                    controller: contentController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Content cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<NotificationCubit, NotificationState>(
                    bloc: _notificationCubit,
                    listener: (context, state) {
                      if (state is NotificationSendSuccess) {
                        Dialogs.showSuccessDialog(context, 'Success',
                            'Notification sent successfully');
                      } else if (state is NotificationSendFailure) {
                        Dialogs.showErrorDialog(
                            context, 'Error', state.message);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is NotificationSendLoading;

                      return MyThirdButton(
                        isLoading: isLoading,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _notificationCubit.sendNotification(
                              title: titleController.text.trim(),
                              content: contentController.text.trim(),
                            );
                          }
                        },
                        buttonText: 'Send Notification',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendSpecificNotification({
    required String userId,
    required String userName,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Text(
              'Send Notification to $userName',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _selectedScreen.value = null; // Go back to selection screen
              },
            ),
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextFieldAdmin(
                    label: 'Title',
                    keyboardType: TextInputType.name,
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  LabeledExpandableTextFieldAdmin(
                    label: 'Content',
                    controller: contentController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Content cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<NotificationCubit, NotificationState>(
                    bloc: _notificationCubit,
                    listener: (context, state) {
                      if (state is NotificationSendSuccess) {
                        Dialogs.showSuccessDialog(context, 'Success',
                            'Notification sent successfully');
                      } else if (state is NotificationSendFailure) {
                        Dialogs.showErrorDialog(
                            context, 'Error', state.message);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is NotificationSendLoading;

                      return MyThirdButton(
                        isLoading: isLoading,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _notificationCubit.sendNotification(
                              title: titleController.text.trim(),
                              content: contentController.text.trim(),
                              userId: userId,
                            );
                          }
                        },
                        buttonText: 'Send Notification',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificUserScreen() {
    List filteredUsers = [];
    ValueNotifier<String> searchQuery = ValueNotifier<String>('');

    return Column(
      children: [
        ListTile(
          title: const Text(
            'Send Notification to a Specific User',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _selectedScreen.value = null; // Go back to selection screen
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<NotificationCubit, NotificationState>(
            bloc: NotificationCubit()..getNotificationUsers(),
            builder: (context, state) {
              if (state is GetNotificationUsersLoading) {
                return const Loader();
              } else if (state is GetNotificationUsersFailure) {
                return Center(child: Text(state.message));
              } else if (state is GetNotificationUsersSuccess) {
                final users = state.users.users;

                return ValueListenableBuilder(
                    valueListenable: searchQuery,
                    builder: (context, value, child) {
                      filteredUsers = users.where((user) {
                        final nameLower = user.name.toString().toLowerCase();
                        final emailLower = user.email.toString().toLowerCase();
                        final searchLower = value.toLowerCase();
                        return nameLower.contains(searchLower) ||
                            emailLower.contains(searchLower);
                      }).toList();

                      return Column(
                        children: [
                          MyTextField(
                            icon: const Icon(Icons.search),
                            hintText: 'Search Users',
                            inputType: TextInputType.text,
                            obscureText: false,
                            onChanged: (p0) {
                              searchQuery.value = p0;
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];

                                return ListTile(
                                  title: Text(user.name.toString()),
                                  subtitle: Text(user.email.toString()),
                                  onTap: () {
                                    _selectedScreen.value =
                                        'send_specific_notification+${user.id}+${user.name}';
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    });
              }

              return const Center(child: Text('An unexpected error occurred.'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsHistoryScreen() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Check Your Notifications History',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _selectedScreen.value = null; // Go back to selection screen
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<NotificationCubit, NotificationState>(
            bloc: NotificationCubit()..getCustomNotifications(),
            builder: (context, state) {
              if (state is GetCustomNotificationsLoading) {
                return const Loader();
              } else if (state is GetCustomNotificationsFailure) {
                return Center(child: Text(state.message));
              } else if (state is GetCustomNotificationsSuccess) {
                final notifications = state.notifications.notifications;

                if (notifications.isEmpty) {
                  return const Center(child: Text('No notifications found.'));
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    return ListTile(
                      title: Text(notification.title.toString()),
                      subtitle: Text(notification.message.toString()),
                      onTap: () {
                        // Handle notification tap
                      },
                    );
                  },
                );
              }

              return const Center(child: Text('An unexpected error occurred.'));
            },
          ),
        ),
      ],
    );
  }
}
