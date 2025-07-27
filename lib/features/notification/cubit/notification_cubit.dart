import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/notification/models/get_notification_model.dart';
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
        '$HOST/notifications',
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
        '$HOST/notifications/$notificationId/read',
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
        '$HOST/notifications/$notificationId',
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
  }) async {
    emit(NotificationSendLoading());

    try {
      final response = await dio.post(
        'https://api.onesignal.com/notifications',
        options: Options(headers: {
          'Authorization': 'Basic $ONE_SIGNAL_API_KEY',
        }),
        data: {
          "app_id": ONE_SIGNAL_APP_ID,
          "target_channel": "push",
          "included_segments": ["Total Subscriptions"],
          "headings": {
            "en": title,
          },
          "contents": {
            "en": content,
          },
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
}
