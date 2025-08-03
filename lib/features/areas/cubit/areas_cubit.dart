import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/features/areas/models/get_service_area_prices_model.dart';

import '../../../consts.dart';
import '../../../main.dart';
import '../../../services/user_token.dart';
import '../models/get_areas_admin_model.dart';
import '../models/get_areas_model.dart';

part 'areas_state.dart';

class AreasCubit extends Cubit<AreasState> {
  AreasCubit() : super(AreasInitial());

  Future<void> getAreas() async {
    emit(GetAreasLoading());

    try {
      final response = await dio.get(
        '$HOST/areas',
      );

      final areas = GetAreasModel.fromJson(response.data);

      emit(GetAreasSuccess(areas: areas));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetAreasFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetAreasFailure(message: 'Failed to get areas.'));
    }
  }

  Future<void> getServiceAreaPrices() async {
    emit(GetServiceAreaPricesLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/admin/service-area-prices',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final serviceAreaPrices =
          GetServiceAreaPricesModel.fromJson(response.data);

      emit(GetServiceAreaPricesSuccess(serviceAreaPrices: serviceAreaPrices));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetServiceAreaPricesFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetServiceAreaPricesFailure(
          message: 'Failed to get service area prices.'));
    }
  }

  Future<void> addServiceAreaPrice({
    required int serviceId,
    required int areaId,
    required double price,
  }) async {
    emit(AddServiceAreaPriceLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.post(
        '$HOST/admin/service-area-prices',
        data: {
          'service_id': serviceId,
          'area_id': areaId,
          'price': price,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      // final serviceAreaPrice =
      //     GetServiceAreaPricesModel.fromJson(response.data);

      emit(AddServiceAreaPriceSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(AddServiceAreaPriceFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(AddServiceAreaPriceFailure(
          message: 'Failed to add service area price.'));
    }
  }

  Future<void> getAreasAdmin() async {
    emit(GetAreasAdminLoading());

    try {
      final response = await dio.get(
        '$HOST/admin/areas',
        options: Options(headers: {
          'Authorization': 'Bearer ${await UserToken.getToken()}',
        }),
      );

      final areas = GetAreasAdminModel.fromJson(response.data);

      emit(GetAreasAdminSuccess(areas: areas));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetAreasAdminFailure(
          message: e.response?.data['message'] ?? 'Failed to get areas.'));
    } catch (e) {
      logger.e(e);
      emit(GetAreasAdminFailure(message: 'Failed to get areas.'));
    }
  }

  Future<void> addArea(String text) async {
    emit(AddAreaLoading());

    try {
      await dio.post(
        '$HOST/admin/areas',
        options: Options(headers: {
          'Authorization': 'Bearer ${await UserToken.getToken()}',
        }),
        data: {'name': text},
      );

      emit(AddAreaSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(AddAreaFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(AddAreaFailure(message: 'Failed to add area.'));
    }
  }

  Future<void> editArea(String text, int areaId) async {
    emit(EditAreaLoading());

    try {
      await dio.put(
        '$HOST/admin/areas/$areaId',
        options: Options(headers: {
          'Authorization': 'Bearer ${await UserToken.getToken()}',
        }),
        data: {'name': text},
      );

      emit(EditAreaSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(EditAreaFailure(
          message: e.response?.data['message'] ?? 'Failed to edit area.'));
    } catch (e) {
      logger.e(e);
      emit(EditAreaFailure(message: 'Failed to edit area.'));
    }
  }
}
