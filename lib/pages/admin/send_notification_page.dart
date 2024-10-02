import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/third_button.dart';
import 'package:nurse_app/features/notification/cubit/notification_cubit.dart';
import 'package:nurse_app/utilities/dialogs.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminHeader(title: 'Send Notification'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  LabeledTextfieldAdmin(
                    label: 'Title',
                    keyboardType: TextInputType.name,
                    controller: titleController,
                  ),
                  const SizedBox(height: 10),
                  LabeledTextfieldAdmin(
                    label: 'Content',
                    keyboardType: TextInputType.name,
                    controller: contentController,
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
                          if (titleController.text.trim().isNotEmpty &&
                              contentController.text.trim().isNotEmpty) {
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
          ],
        ),
      ),
    );
  }
}
