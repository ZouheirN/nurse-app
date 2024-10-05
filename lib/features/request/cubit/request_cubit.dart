import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

part 'request_state.dart';

final dio = Dio();

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInitial());

  Future<void> createRequest({
    required String name,
    required String phoneNumber,
    required String location,
    required String problemDescription,
    required String nurseGender,
    String? timeType,
    required List<int> selectedServices,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(RequestCreateLoading());

    try {
      final token = await UserToken.getToken();

      final data = {
        "service_ids": selectedServices,
        "location": location,
        "problem_description": problemDescription,
        "nurse_gender": nurseGender,
        "full_name": name,
        "phone_number": phoneNumber,
        "scheduled_time": DateTime.now().toIso8601String(),
      };

      if (startDate != null) {
        data['scheduled_time'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        data['ending_time'] = endDate.toIso8601String();
        data['time_type'] = timeType!;
      }

      await dio.post(
        '$HOST/requests',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: data,
      );

      emit(RequestCreateSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(RequestCreateFailure(
          message: e.response!.data['error'] ?? 'Failed to create request.'));
    } catch (e) {
      logger.e(e);
      emit(RequestCreateFailure(message: 'Failed to create request.'));
    }
  }

  Future<void> getRequestsHistory({bool isAdmin = false}) async {
    emit(RequestsHistoryLoading());

    try {
      final token = await UserToken.getToken();

      final url = isAdmin ? '$HOST/admin/requests' : '$HOST/requests';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<RequestsHistoryModel> requests = response.data['requests']
          .map<RequestsHistoryModel>(
              (request) => RequestsHistoryModel.fromJson(request))
          .toList();

      emit(RequestsHistorySuccess(requests: requests));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(RequestsHistoryFailure(message: e.response!.data['error']));
    } catch (e) {
      logger.e(e);
      emit(RequestsHistoryFailure(message: 'Failed to create request.'));
    }
  }

  Future<void> getOrder({
    required num orderId,
    bool skipLoading = false,
  }) async {
    if (!skipLoading) emit(RequestDetailsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/requests/$orderId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final request = RequestsHistoryModel.fromJson(response.data);

      emit(RequestDetailsSuccess(request: request));
    } on DioException catch (e) {
      logger.e(e.response!.statusCode);
      emit(RequestDetailsFailure(message: e.response!.data['error']));
    } catch (e) {
      logger.e(e);
      emit(RequestDetailsFailure(message: 'Failed to create request.'));
    }
  }

  Future<void> submitRequest({
    required num id,
    required String status,
    required DateTime scheduledTime,
    required int? timeNeededToArrive,
    required DateTime? endingTime,
    required String location,
    required num nurseId,
    required List<num> serviceIds,
    required String? timeType,
    required String? problemDescription,
    required String nurseGender,
  }) async {
    emit(RequestSubmitLoading());

    try {
      final token = await UserToken.getToken();

      final data = {
        'status': status,
        'location': location,
        'nurse_id': nurseId,
        'service_ids': serviceIds,
        'problem_description': problemDescription,
        'nurse_gender': nurseGender,
      };

      if (endingTime == null) {
        data['time_needed_to_arrive'] = timeNeededToArrive;
      } else {
        data['scheduled_time'] = scheduledTime.toIso8601String();
        data['ending_time'] = endingTime.toIso8601String();
        data['time_type'] = timeType;
      }

      await dio.put(
        '$HOST/admin/requests/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: data,
      );

      emit(RequestSubmitSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(RequestSubmitFailure(message: 'Failed to submit request.'));
    } catch (e) {
      logger.e(e);
      emit(RequestSubmitFailure(message: 'Failed to submit request.'));
    }
  }

  Future<void> setStatus({
    required RequestsHistoryModel order,
    required String status,
  }) async {
    emit(RequestSetStatusLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.put(
        '$HOST/admin/requests/${order.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'status': status,
        },
      );

      final updatedOrder = response.data['request'];

      emit(RequestSetStatusSuccess(
          request: RequestsHistoryModel.fromJson(updatedOrder)));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(RequestSetStatusFailure(message: 'Failed to submit request.'));
    } catch (e) {
      logger.e(e);
      emit(RequestSetStatusFailure(message: 'Failed to submit request.'));
    }
  }

  Future<void> emitRequestDetailsSuccess({
    required RequestsHistoryModel order,
    required String status,
  }) async {
    final updatedOrder =
        RequestsHistoryModel.fromJson(order.toJson()..['status'] = status);

    emit(RequestDetailsSuccess(request: updatedOrder));
  }

  Future<void> deleteOrder({
    required RequestsHistoryModel order,
  }) async {
    emit(RequestDeleteLoading());

    try {
      final token = await UserToken.getToken();

      await dio.delete(
        '$HOST/admin/requests/${order.id}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(RequestDeleteSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(RequestDeleteFailure(message: 'Failed to delete request.'));
    } catch (e) {
      logger.e(e);
      emit(RequestDeleteFailure(message: 'Failed to delete request.'));
    }
  }
}
