import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/home/models/get_popups_model.dart';

import '../../../main.dart';
import '../../../services/user_token.dart';
import '../models/get_sliders_model.dart';

part 'home_state.dart';

final dio = Dio();

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getPopups() async {
    emit(GetPopupsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/popups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final popups = GetPopupsModel.fromJson(response.data);

      emit(GetPopupsSuccess(popups: popups));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetPopupsFailure(message: e.response!.data['error']));
    } catch (e) {
      logger.e(e);
      emit(GetPopupsFailure(message: 'Failed to get popups.'));
    }
  }

  Future<void> getSliders() async {
    emit(GetSlidersLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/sliders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept' : 'application/json',
          },
        ),
      );

      final sliders = GetSlidersModel.fromJson(response.data);

      emit(GetSlidersSuccess(sliders: sliders));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      logger.e(e.response!.statusCode);
      emit(GetSlidersFailure(message: e.response!.data['error']));
    } catch (e) {
      logger.e(e);
      emit(GetSlidersFailure(message: 'Failed to get popups.'));
    }
  }
}
