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
      logger.e(e.response!.data);
      emit(ServicesFetchFailure(message: 'Failed to fetch services.'));
    } catch (e) {
      logger.e(e);
      emit(ServicesFetchFailure(message: 'Failed to fetch services.'));
    }
  }

  Future<void> fetchService({
    required num serviceId,
  }) async {
    emit(ServicesFetchDetailsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/services/$serviceId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(ServicesFetchDetailsSuccess(service: response.data['service']));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(ServicesFetchDetailsFailure(
          message: 'Failed to fetch service details.'));
    } catch (e) {
      logger.e(e);
      emit(ServicesFetchDetailsFailure(
          message: 'Failed to fetch service details.'));
    }
  }

  Future<void> editService({
    required num serviceId,
    required String name,
    required num price,
    required num? discountPrice,
    required String? image,
  }) async {
    emit(ServicesEditLoading());

    try {
      final token = await UserToken.getToken();

      await dio.put(
        '$HOST/admin/services/$serviceId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "name": name,
          "price": price,
          "discount_price": discountPrice,
          "service_pic": image,
        },
      );

      emit(ServicesEditSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(ServicesEditFailure(message: 'Failed to edit service.'));
    } catch (e) {
      logger.e(e);
      emit(ServicesEditFailure(message: 'Failed to edit service.'));
    }
  }

  Future<void> addService({
    required String name,
    required num price,
    required num? discountPrice,
    required String? image,
  }) async {
    emit(ServiceAddLoading());

    try {
      final token = await UserToken.getToken();

      await dio.post(
        '$HOST/admin/services',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "name": name,
          "price": price,
          "discount_price": discountPrice,
          "service_pic": image,
        },
      );

      emit(ServiceAddSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(ServiceAddFailure(message: 'Failed to add service.'));
    } catch (e) {
      logger.e(e);
      emit(ServiceAddFailure(message: 'Failed to add service.'));
    }
  }
}
