import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/services/user_token.dart';

import '../../../consts.dart';
import '../models/get_areas_model.dart';

part 'authentication_state.dart';

final dio = Dio();

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> signUp({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String dateOfBirth,
    required int areaId,
  }) async {
    emit(AuthenticationSignUpLoading());

    try {
      await dio.post(
        '$HOST/register',
        data: {
          'name': name,
          'phone_number': phoneNumber,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'birth_date': dateOfBirth,
          'area_id': areaId,
        },
      );

      emit(AuthenticationSignUpSuccess(phoneNumber: phoneNumber));
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        emit(AuthenticationSignUpFailure(
            message: e.response!.data['errors']['email'][0]));
      } else {
        emit(AuthenticationSignUpFailure(message: e.response!.data['message']));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(AuthenticationSignUpFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthenticationSignInLoading());

    try {
      final response = await dio.post(
        '$HOST/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      UserToken.setToken(response.data['token']);

      final userModel = UserModel.fromJson(response.data['user']);
      UserBox.saveUser(userModel);

      loginUser(userModel.id!, userModel.roleId!);

      emit(AuthenticationSignInSuccess(userModel: userModel));
    } on DioException catch (e) {
      emit(AuthenticationSignInFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e.toString());
      emit(AuthenticationSignInFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String pin,
  }) async {
    emit(AuthenticationOtpLoading());

    try {
      final response = await dio.post(
        '$HOST/verify-sms',
        data: {
          'phone_number': phoneNumber,
          'verification_code': pin,
        },
      );

      UserToken.setToken(response.data['token']);

      final userModel = UserModel.fromJson(response.data['user']);
      UserBox.saveUser(userModel);

      loginUser(userModel.id!, userModel.roleId!);

      emit(AuthenticationOtpSuccess());
    } on DioException catch (e) {
      emit(AuthenticationOtpFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e.toString());
      emit(AuthenticationOtpFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }

  Future<void> sendForgotPasswordOtp({required String phoneNumber}) async {
    emit(AuthenticationForgotPasswordOtpLoading());

    try {
      await dio.post(
        '$HOST/send-password-reset-otp',
        data: {
          'phone_number': phoneNumber,
        },
      );

      emit(AuthenticationForgotPasswordOtpSuccess());
    } on DioException catch (e) {
      if (e.response!.statusCode == 422) {
        emit(AuthenticationForgotPasswordOtpFailure(
            message: e.response!.data['errors']['phone_number'][0]));
      } else {
        emit(AuthenticationForgotPasswordOtpFailure(
            message: e.response!.data['message']));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(AuthenticationForgotPasswordOtpFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }

  void verifyForgotPasswordOtp({
    required String phoneNumber,
    required String pin,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthenticationOtpLoading());

    try {
      await dio.post(
        '$HOST/reset-password',
        data: {
          'phone_number': phoneNumber,
          'token': pin,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );

      emit(AuthenticationOtpSuccess());
    } on DioException catch (e) {
      emit(AuthenticationOtpFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e.toString());
      emit(AuthenticationOtpFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }

  Future<bool> resendOtp(String phoneNumber) async {
    try {
      await dio.post(
        '$HOST/resend-verification-code',
        data: {
          'phone_number': phoneNumber,
        },
      );

      return true;
    } on DioException catch (e) {
      logger.e(e.response!.data);
    } catch (e) {
      logger.e(e.toString());
    }

    return false;
  }

  Future<void> getAreas() async {
    emit(AuthenticationGetAreasLoading());

    try {
      final response = await dio.get(
        '$HOST/areas',
      );

      final areas = GetAreasModel.fromJson(response.data);

      emit(AuthenticationGetAreasSuccess(areas: areas));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(AuthenticationGetAreasFailure(message: e.response!.data['error']));
    } catch (e) {
      logger.e(e);
      emit(AuthenticationGetAreasFailure(message: 'Failed to get areas.'));
    }
  }
}
