import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/nurse/models/nurses_model.dart';
import 'package:nurse_app/main.dart';

import '../../../services/user_token.dart';
import '../models/nurse_model.dart';

part 'nurse_state.dart';

final dio = Dio();

class NurseCubit extends Cubit<NurseState> {
  NurseCubit() : super(NurseInitial());

  Future<void> fetchNurses({
    String? selectedGender,
  }) async {
    emit(NurseFetchLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/nurses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final nurses = NursesModel.fromJson(response.data);

      // Filter nurses
      final filteredNurses = nurses.nurses!.where((nurse) {
        if (selectedGender != null && nurse.gender != selectedGender) {
          return false;
        }
        return true;
      }).toList();

      emit(NurseFetchSuccess(nurses: NursesModel(nurses: filteredNurses)));
    } on DioException catch (e) {
      logger.e(e);
      emit(NurseFetchFailure(message: 'Failed to fetch nurses'));
    } catch (e) {
      logger.e(e);
      emit(NurseFetchFailure(message: e.toString()));
    }
  }

  Future<void> fetchNurse(num nurseId) async {
    emit(NurseDetailsFetchLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/nurses/$nurseId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final nurse = NurseModel.fromJson(response.data);

      emit(NurseDetailsFetchSuccess(nurse: nurse));
    } on DioException catch (e) {
      logger.e(e);
      emit(NurseDetailsFetchFailure(message: 'Failed to fetch nurse details'));
    } catch (e) {
      logger.e(e);
      emit(NurseDetailsFetchFailure(message: e.toString()));
    }
  }

  Future<void> setRating(
    num nurseId,
    double rating,
  ) async {
    emit(NurseRatingSetLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.post(
        '$HOST/nurses/$nurseId/rate',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {
          'rating': rating,
        },
      );

      logger.i(response.data);

      emit(NurseRatingSetSuccess(rating: response.data['rating']['rating']));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(NurseRatingSetFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(NurseRatingSetFailure(
          message:
              'Failed to set rating, please check your internet connection'));
    }
  }
}
