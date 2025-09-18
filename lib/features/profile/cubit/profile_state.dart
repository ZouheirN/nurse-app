part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

// Get Profile
final class GetProfileLoading extends ProfileState {}

final class GetProfileSuccess extends ProfileState {
  final GetProfileModel profile;

  GetProfileSuccess({
    required this.profile,
  });
}

final class GetProfileFailure extends ProfileState {
  final String message;

  GetProfileFailure({
    required this.message,
  });
}

// Update Profile
final class UpdateProfileLoading extends ProfileState {}

final class UpdateProfileSuccess extends ProfileState {
  final GetProfileModel profile;

  UpdateProfileSuccess({
    required this.profile,
  });
}

final class UpdateProfileFailure extends ProfileState {
  final String message;

  UpdateProfileFailure({
    required this.message,
  });
}
