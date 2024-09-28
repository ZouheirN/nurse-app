part of 'location_cubit.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

// Update location
final class LocationUpdateLoading extends LocationState {}

final class LocationUpdateSuccess extends LocationState {}

final class LocationUpdateFailure extends LocationState {
  final String message;

  LocationUpdateFailure({required this.message});
}