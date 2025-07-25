part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class GetPopupsLoading extends HomeState {}

final class GetPopupsSuccess extends HomeState {
  final GetPopupsModel popups;

  GetPopupsSuccess({
    required this.popups,
  });
}

final class GetPopupsFailure extends HomeState {
  final String message;

  GetPopupsFailure({
    required this.message,
  });
}

final class GetSlidersLoading extends HomeState {}
final class GetSlidersSuccess extends HomeState {
  final GetSlidersModel sliders;

  GetSlidersSuccess({
    required this.sliders,
  });
}
final class GetSlidersFailure extends HomeState {
  final String message;

  GetSlidersFailure({
    required this.message,
  });
}
