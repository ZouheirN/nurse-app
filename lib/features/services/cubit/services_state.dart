part of 'services_cubit.dart';

@immutable
sealed class ServicesState {}

final class ServicesInitial extends ServicesState {}

final class ServicesFetchLoading extends ServicesState {}

final class ServicesFetchSuccess extends ServicesState {
  final List<dynamic> services;

  ServicesFetchSuccess({required this.services});
}

final class ServicesFetchFailure extends ServicesState {
  final String message;

  ServicesFetchFailure({required this.message});
}