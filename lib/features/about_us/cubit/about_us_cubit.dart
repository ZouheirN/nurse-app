import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';

part 'about_us_state.dart';

final dio = Dio();

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() : super(AboutUsInitial());

  Future<void> fetchAboutUs() async {
    emit(AboutUsFetchLoading());

    try {
      final response = await dio.get(
        '$HOST/about', // todo fix
      );

      emit(AboutUsFetchSuccess(aboutUs: response.data['about']));
    } catch (e) {
      logger.e(e);
      emit(AboutUsFetchFailure(message: 'Failed to fetch about us.'));
    }
  }
}
