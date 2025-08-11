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

// Add Slider
final class AddSliderLoading extends HomeState {}

final class AddSliderSuccess extends HomeState {}

final class AddSliderFailure extends HomeState {
  final String message;

  AddSliderFailure({
    required this.message,
  });
}

// Delete Slider
final class DeleteSliderLoading extends HomeState {}
final class DeleteSliderSuccess extends HomeState {}
final class DeleteSliderFailure extends HomeState {
  final String message;

  DeleteSliderFailure({
    required this.message,
  });
}

// Reorder Sliders
final class ReorderSlidersLoading extends HomeState {}
final class ReorderSlidersSuccess extends HomeState {}
final class ReorderSlidersFailure extends HomeState {
  final String message;

  ReorderSlidersFailure({
    required this.message,
  });
}