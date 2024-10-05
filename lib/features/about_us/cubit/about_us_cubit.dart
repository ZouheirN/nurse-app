import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

part 'about_us_state.dart';

final dio = Dio();

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() : super(AboutUsInitial());

  Future<void> fetchAboutUs() async {
    emit(AboutUsFetchLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/about',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(AboutUsFetchSuccess(aboutUs: response.data['about']));
    } catch (e) {
      logger.e(e);
      emit(AboutUsFetchFailure(message: 'Failed to fetch about us.'));
    }
  }

  Future<void> updateAboutUs({
    required String website,
    required String instagram,
    required String facebook,
    required List<String> whatsapp,
  }) async {
    emit(AboutUsUpdateLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.put(
        '$HOST/admin/about',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'online_shop_url': website,
          'instagram_url': instagram,
          'facebook_url': facebook,
          'whatsapp_number': whatsapp,
        },
      );

      emit(AboutUsUpdateSuccess(aboutUs: response.data['about']));
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(AboutUsUpdateFailure(message: e.response?.data['message']));
    } catch (e) {
      logger.e(e);
      emit(AboutUsUpdateFailure(message: 'Failed to update about us.'));
    }
  }
}
