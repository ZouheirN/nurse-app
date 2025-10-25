import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../consts.dart';
import '../../../main.dart';
import '../../../services/user_token.dart';
import '../models/get_profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(GetProfileLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '${Consts.host}/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      logger.i(response.data);

      final profile = GetProfileModel.fromJson(response.data);

      emit(GetProfileSuccess(profile: profile));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetProfileFailure(
          message: e.response!.data['message'] ?? 'Failed to fetch users'));
    } catch (e) {
      logger.e(e);
      emit(GetProfileFailure(message: e.toString()));
    }
  }

  Future<void> updateProfile({
    required num id,
    String? name,
    String? email,
    String? phoneNumber,
    String? location,
    String? birthDate,
  }) async {
    emit(UpdateProfileLoading());

    try {
      final token = await UserToken.getToken();

      final data = {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (location != null) 'location': location,
        if (birthDate != null) 'birth_date': birthDate,
      };

      logger.i(data);

      final response = await dio.put(
        '${Consts.host}/users/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: data,
      );

      final profile = GetProfileModel.fromJson(response.data['user']);

      emit(UpdateProfileSuccess(profile: profile));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(UpdateProfileFailure(
          message: e.response!.data['message'] ?? 'Failed to update profile'));
    } catch (e) {
      logger.e(e);
      emit(UpdateProfileFailure(message: e.toString()));
    }
  }
}
