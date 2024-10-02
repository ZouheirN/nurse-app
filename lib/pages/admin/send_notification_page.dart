import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/labeled_expandable_textfield_admin.dart';
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

  final _formKey = GlobalKey<FormState>();

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
      ),
    );
  }
}
