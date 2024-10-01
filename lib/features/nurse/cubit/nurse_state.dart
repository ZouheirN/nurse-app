part of 'nurse_cubit.dart';

@immutable
sealed class NurseState {}

final class NurseInitial extends NurseState {}

final class NurseDetailsFetchLoading extends NurseState {}

final class NurseDetailsFetchSuccess extends NurseState {
  final NurseModel nurse;

  NurseDetailsFetchSuccess({required this.nurse});
}

final class NurseDetailsFetchFailure extends NurseState {
  final String message;

  NurseDetailsFetchFailure({required this.message});
}