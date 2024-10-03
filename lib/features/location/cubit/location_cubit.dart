import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/services/user_token.dart';

part 'location_state.dart';

final dio = Dio();

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    required String locationDetails,
  }) async {
    emit(LocationUpdateLoading());

    try {
      final token = await UserToken.getToken();

      await dio.post(
        '$HOST/submit-location',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      await updateLocationDetails(locationDetails: locationDetails);

      emit(LocationUpdateSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(LocationUpdateFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e.toString());
      emit(LocationUpdateFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }

  Future<void> updateLocationDetails({
    required String locationDetails,
  }) async {
    emit(LocationUpdateLoading());

    final userId = UserBox.getUser()!.id;

    try {
      final token = await UserToken.getToken();

      await dio.put(
        '$HOST/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'location': locationDetails,
        },
      );

      emit(LocationUpdateSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(LocationUpdateFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e.toString());
      emit(LocationUpdateFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }
}
