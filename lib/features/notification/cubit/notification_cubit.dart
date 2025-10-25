import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/notification/models/get_custom_notifcations_model.dart'
    as custom;
import 'package:nurse_app/features/notification/models/get_notification_model.dart';
import 'package:nurse_app/features/notification/models/get_notification_users_model.dart';
import 'package:nurse_app/main.dart';

import '../../../services/user_token.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(GetNotificationsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '${Consts.host}/notifications',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      logger.i(response.data);

      emit(GetNotificationsSuccess(
        notifications: GetNotificationsModel.fromJson(response.data),
      ));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetNotificationsFailure(message: 'Failed to fetch notifications'));
    } catch (e) {
      emit(GetNotificationsFailure(message: 'Failed to fetch notifications'));
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    emit(MarkNotificationAsReadLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.post(
        '${Consts.host}/notifications/$notificationId/read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(MarkNotificationAsReadSuccess(message: response.data['message']));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(MarkNotificationAsReadFailure(
          message: 'Failed to mark notification as read'));
    } catch (e) {
      emit(MarkNotificationAsReadFailure(message: e.toString()));
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    emit(DeleteNotificationLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.delete(
        '${Consts.host}/notifications/$notificationId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(DeleteNotificationSuccess(message: response.data['message']));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(DeleteNotificationFailure(message: 'Failed to delete notification'));
    } catch (e) {
      emit(DeleteNotificationFailure(message: e.toString()));
    }
  }

  Future<void> markNotificationAsReadFromList(
      List<Notification> notifications, int notificationId) async {
    notifications = notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(readAt: DateTime.now());
      }
      return notification;
    }).toList();
    emit(GetNotificationsSuccess(
        notifications: GetNotificationsModel(notifications: notifications)));
  }

  Future<void> deleteNotificationFromList(
      List<Notification> notifications, int notificationId) async {
    notifications = notifications.where((notification) {
      return notification.id != notificationId;
    }).toList();
    emit(GetNotificationsSuccess(
        notifications: GetNotificationsModel(notifications: notifications)));
  }

  Future<void> sendNotification({
    required String title,
    required String content,
    String? userId,
  }) async {
    emit(NotificationSendLoading());

    try {
      // final response = await dio.post(
      //   'https://api.onesignal.com/notifications',
      //   options: Options(headers: {
      //     'Authorization': 'Basic $ONE_SIGNAL_API_KEY',
      //   }),
      //   data: {
      //     "app_id": ONE_SIGNAL_APP_ID,
      //     "target_channel": "push",
      //     "included_segments": ["Total Subscriptions"],
      //     "headings": {
      //       "en": title,
      //     },
      //     "contents": {
      //       "en": content,
      //     },
      //   },
      // );

      final response = await dio.post(
        '${Consts.host}/admin/notifications/custom',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await UserToken.getToken()}',
          },
        ),
        data: {
          "user_id": userId,
          "title": title,
          "message": content,
        },
      );

      logger.i(response.data);

      emit(NotificationSendSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(NotificationSendFailure(message: 'Failed to send notification'));
    } catch (e) {
      emit(NotificationSendFailure(message: e.toString()));
    }
  }

  Future<void> getNotificationUsers() async {
    emit(GetNotificationUsersLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '${Consts.host}/admin/notifications/users',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final users = GetNotificationUsersModel.fromJson(response.data);

      emit(GetNotificationUsersSuccess(users: users));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetNotificationUsersFailure(
          message: e.response!.data['message'] ?? 'Failed to fetch users'));
    } catch (e) {
      emit(GetNotificationUsersFailure(message: 'Failed to fetch users'));
    }
  }

  Future<void> getCustomNotifications() async {
    emit(GetCustomNotificationsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '${Consts.host}/admin/notifications/custom',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(GetCustomNotificationsSuccess(
        notifications:
            custom.GetCustomNotificationsModel.fromJson(response.data),
      ));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetCustomNotificationsFailure(
          message:
              e.response!.data['message'] ?? 'Failed to fetch notifications'));
    } catch (e) {
      emit(GetCustomNotificationsFailure(
          message: 'Failed to fetch notifications'));
    }
  }
}
