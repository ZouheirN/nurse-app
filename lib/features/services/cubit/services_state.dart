part of 'services_cubit.dart';

@immutable
sealed class ServicesState {}

final class ServicesInitial extends ServicesState {}

final class ServicesFetchLoading extends ServicesState {}

final class ServicesFetchSuccess extends ServicesState {
  final GetServicesModel services;

  ServicesFetchSuccess({required this.services});
}

final class ServicesFetchFailure extends ServicesState {
  final String message;

  ServicesFetchFailure({required this.message});
}

// Fetch Services From Area

final class ServicesFetchFromAreaLoading extends ServicesState {}

final class ServicesFetchFromAreaSuccess extends ServicesState {
  final GetServicesFromAreaModel services;

  ServicesFetchFromAreaSuccess({required this.services});
}

final class ServicesFetchFromAreaFailure extends ServicesState {
  final String message;

ServicesFetchFromAreaFailure({required this.message});
}

final class ServicesFetchDetailsLoading extends ServicesState {}

final class ServicesFetchDetailsSuccess extends ServicesState {
  final Map<String, dynamic> service;

  ServicesFetchDetailsSuccess({required this.service});
}

final class ServicesFetchDetailsFailure extends ServicesState {
  final String message;

  ServicesFetchDetailsFailure({required this.message});
}

final class ServicesEditLoading extends ServicesState {}

final class ServicesEditSuccess extends ServicesState {}

final class ServicesEditFailure extends ServicesState {
  final String message;

  ServicesEditFailure({required this.message});
}

final class ServiceAddLoading extends ServicesState {}

final class ServiceAddSuccess extends ServicesState {}

final class ServiceAddFailure extends ServicesState {
  final String message;

  ServiceAddFailure({required this.message});
}