import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/features/services/models/get_services_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

import '../../../consts.dart';
import '../models/get_services_from_area_model.dart';

part 'services_state.dart';

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

      final services = GetServicesModel.fromJson(response.data);

      emit(ServicesFetchSuccess(services: services));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(ServicesFetchFailure(message: 'Failed to fetch services.'));
    } catch (e) {
      logger.e(e);
      emit(ServicesFetchFailure(message: 'Failed to fetch services.'));
    }
  }

  Future<void> fetchServicesFromArea({required int areaId}) async {
    emit(ServicesFetchFromAreaLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/services/area/$areaId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final services = GetServicesFromAreaModel.fromJson(response.data);

      emit(ServicesFetchFromAreaSuccess(services: services));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(ServicesFetchFromAreaFailure(message: 'Failed to fetch services.'));
    } catch (e) {
      logger.e(e);
      emit(ServicesFetchFromAreaFailure(message: 'Failed to fetch services.'));
    }
  }

  Future<void> quoteServices({
    required List<int> serviceIds,
    required int areaId,
  }) async {
    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/services/quote',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "service_ids": serviceIds,
          "area_id": areaId,
        },
      );

      logger.i(response.data);

      final services = GetServicesModel.fromJson(response.data);

      emit(ServicesFetchSuccess(services: services));
    } on DioException catch (e) {
      logger.e(e.response!.data);
    } catch (e) {
      logger.e(e);
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
