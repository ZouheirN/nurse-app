import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/request/models/requests_history_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

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
    required String timeType,
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
        "time_type": timeType,
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
      emit(RequestCreateFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(RequestCreateFailure(message: 'Failed to create request.'));
    }
  }

  Future<void> getRequestsHistory() async {
    emit(RequestsHistoryLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/requests',
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
}
