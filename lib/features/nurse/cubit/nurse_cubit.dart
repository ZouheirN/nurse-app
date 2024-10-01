import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';

import '../../../services/user_token.dart';
import '../models/nurse_model.dart';

part 'nurse_state.dart';

final dio = Dio();

class NurseCubit extends Cubit<NurseState> {
  NurseCubit() : super(NurseInitial());

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
}
