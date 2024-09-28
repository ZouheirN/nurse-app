import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:nurse_app/features/authentication/models/user_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:nurse_app/utilities/hashing.dart';

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

    password = encryptString(password);
    passwordConfirmation = encryptString(passwordConfirmation);

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

    password = encryptString(password);

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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber,
          'verification_code': pin,
        }),
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = jsonData['token'];

        UserToken.setToken(token);

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
