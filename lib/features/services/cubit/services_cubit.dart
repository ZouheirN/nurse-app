import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

import '../../../consts.dart';

part 'services_state.dart';

final dio = Dio();

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesFetchLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/services',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(ServicesFetchSuccess(services: response.data['services']));
    } on DioException catch (e) {
      emit(ServicesFetchFailure(message: 'Failed to fetch services.'));
    } catch (e) {
      logger.e(e);
      emit(ServicesFetchFailure(message: 'Failed to fetch services.'));
    }
  }
}
