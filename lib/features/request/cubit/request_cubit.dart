import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:nurse_app/utilities/helper_functions.dart';

part 'request_state.dart';

final dio = Dio();

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInitial());

  Future<void> createRequestImmediate({
    required String name,
    required String phoneNumber,
    required String location,
    required String problemDescription,
    required String nurseGender,
    required String timeType,
    required List<int> selectedServices,
  }) async {
    emit(RequestImmediateLoading());

    logger.d(
        'Creating request immediate with: $name, $phoneNumber, $location, $problemDescription, $nurseGender, $timeType, $selectedServices');

    try {
      final token = await UserToken.getToken();

      final response = await dio.post(
        '$HOST/requests',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "service_ids": selectedServices,
          "location": location,
          "time_type": timeType,
          "problem_description": problemDescription,
          "nurse_gender": nurseGender,
          "full_name": name,
          "phone_number": phoneNumber,
          "scheduled_time": convertDateTime(DateTime.now()),
        },
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        emit(RequestImmediateSuccess());
      } else {
        logger.e('${response.data}');
        emit(RequestImmediateFailure(message: response.data['message']));
      }
    } catch (e) {
      logger.e(e);
      emit(RequestImmediateFailure(message: 'Failed to create request.'));
    }
  }
}
