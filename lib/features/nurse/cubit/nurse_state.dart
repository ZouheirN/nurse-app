part of 'nurse_cubit.dart';

@immutable
sealed class NurseState {}

final class NurseInitial extends NurseState {}

final class NurseFetchLoading extends NurseState {}

final class NurseFetchSuccess extends NurseState {
  final NursesModel nurses;

  NurseFetchSuccess({required this.nurses});
}

final class NurseFetchFailure extends NurseState {
  final String message;

  NurseFetchFailure({required this.message});
}

final class NurseDetailsFetchLoading extends NurseState {}

final class NurseDetailsFetchSuccess extends NurseState {
  final NurseModel nurse;

  NurseDetailsFetchSuccess({required this.nurse});
}

final class NurseDetailsFetchFailure extends NurseState {
  final String message;

  NurseDetailsFetchFailure({required this.message});
}

final class NurseRatingSetLoading extends NurseState {}

final class NurseRatingSetSuccess extends NurseState {
  final int rating;

  NurseRatingSetSuccess({required this.rating});
}

final class NurseRatingSetFailure extends NurseState {
  final String message;

  NurseRatingSetFailure({required this.message});
}