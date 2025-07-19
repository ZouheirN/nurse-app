import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/notification/models/get_notification_model.dart';
import 'package:nurse_app/main.dart';

import '../../../services/user_token.dart';

part 'notification_state.dart';

final dio = Dio();

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
