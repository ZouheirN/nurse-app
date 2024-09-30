import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/services/user_token.dart';

import '../../../consts.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> signUp({
    required String name,
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthenticationSignUpLoading());

    try {
      final response = await http.post(
        Uri.parse('$HOST/register'),
        body: {
          'name': name,
          'phone_number': phoneNumber,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(AuthenticationSignUpSuccess(phoneNumber: phoneNumber));
      } else if (response.statusCode == 422) {
        emit(AuthenticationSignUpFailure(
            message: jsonData['errors']['email'][0]));
      } else {
        emit(AuthenticationSignUpFailure(message: jsonData['error']));
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
      final response = await http.post(
        Uri.parse('$HOST/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        UserToken.setToken(jsonData['token']);

        final userModel = UserModel.fromJson(jsonData['user']);
        UserBox.saveUser(userModel);

        loginUser(userModel.id!, userModel.roleId!);

        emit(AuthenticationSignInSuccess(userModel: userModel));
      } else {
        emit(AuthenticationSignInFailure(message: jsonData['message']));
      }
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
      final response = await http.post(
        Uri.parse('$HOST/verify-sms'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone_number': phoneNumber,
          'verification_code': pin,
        }),
      );

      final jsonData = json.decode(response.body);

      logger.i(jsonData);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        UserToken.setToken(jsonData['token']);

        final userModel = UserModel.fromJson(jsonData['user']);
        UserBox.saveUser(userModel);

        loginUser(userModel.id!, userModel.roleId!);

        emit(AuthenticationOtpSuccess());
      } else {
        emit(AuthenticationOtpFailure(message: jsonData['message']));
      }
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
      final response = await http.post(
        Uri.parse('$HOST/send-password-reset-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber,
        }),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(AuthenticationForgotPasswordOtpSuccess());
      } else if (response.statusCode == 422) {
        emit(AuthenticationForgotPasswordOtpFailure(
            message: jsonData['errors']['phone_number'][0]));
      } else {
        emit(AuthenticationForgotPasswordOtpFailure(
            message: jsonData['message']));
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
      final response = await http.post(
        Uri.parse('$HOST/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber,
          'token': pin,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(AuthenticationOtpSuccess());
      } else {
        emit(AuthenticationOtpFailure(message: jsonData['message']));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(AuthenticationOtpFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }
}
