part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

// Sign up
final class AuthenticationSignUpLoading extends AuthenticationState {}

final class AuthenticationSignUpSuccess extends AuthenticationState {
  final String phoneNumber;

  AuthenticationSignUpSuccess({required this.phoneNumber});
}

final class AuthenticationSignUpFailure extends AuthenticationState {
  final String message;

  AuthenticationSignUpFailure({required this.message});
}

// Sign in
final class AuthenticationSignInLoading extends AuthenticationState {}

final class AuthenticationSignInSuccess extends AuthenticationState {
  final UserModel userModel;

  AuthenticationSignInSuccess({required this.userModel});
}

final class AuthenticationSignInFailure extends AuthenticationState {
  final String message;

  AuthenticationSignInFailure({required this.message});
}

// OTP
final class AuthenticationOtpLoading extends AuthenticationState {}

final class AuthenticationOtpSuccess extends AuthenticationState {}

final class AuthenticationOtpFailure extends AuthenticationState {
  final String message;

  AuthenticationOtpFailure({required this.message});
}

// Forgot password
final class AuthenticationForgotPasswordOtpLoading extends AuthenticationState {}

final class AuthenticationForgotPasswordOtpSuccess extends AuthenticationState {}

final class AuthenticationForgotPasswordOtpFailure extends AuthenticationState {
  final String message;

  AuthenticationForgotPasswordOtpFailure({required this.message});
}
