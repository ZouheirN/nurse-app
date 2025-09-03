part of 'areas_cubit.dart';

@immutable
sealed class AreasState {}

final class AreasInitial extends AreasState {}

// Get areas
final class GetAreasLoading extends AreasState {}

final class GetAreasSuccess extends AreasState {
  final GetAreasModel areas;

  GetAreasSuccess({required this.areas});
}

final class GetAreasFailure extends AreasState {
  final String message;

  GetAreasFailure({required this.message});
}

// Get service area prices
final class GetServiceAreaPricesLoading extends AreasState {}

final class GetServiceAreaPricesSuccess extends AreasState {
  final GetServiceAreaPricesModel serviceAreaPrices;

  GetServiceAreaPricesSuccess({required this.serviceAreaPrices});
}

final class GetServiceAreaPricesFailure extends AreasState {
  final String message;

  GetServiceAreaPricesFailure({required this.message});
}

// Get service area prices for service
final class GetServiceAreaPricesForServiceLoading extends AreasState {}

final class GetServiceAreaPricesForServiceSuccess extends AreasState {
  final GetServiceAreaPricesForService serviceAreaPrices;

  GetServiceAreaPricesForServiceSuccess({required this.serviceAreaPrices});
}

final class GetServiceAreaPricesForServiceFailure extends AreasState {
  final String message;

  GetServiceAreaPricesForServiceFailure({required this.message});
}

// Add service area price
final class AddServiceAreaPriceLoading extends AreasState {}

final class AddServiceAreaPriceSuccess extends AreasState {}

final class AddServiceAreaPriceFailure extends AreasState {
  final String message;

  AddServiceAreaPriceFailure({required this.message});
}

// Edit service area price
final class EditServiceAreaPriceLoading extends AreasState {}
final class EditServiceAreaPriceSuccess extends AreasState {}
final class EditServiceAreaPriceFailure extends AreasState {
  final String message;

  EditServiceAreaPriceFailure({required this.message});
}

// Get Areas Admin
final class GetAreasAdminLoading extends AreasState {}

final class GetAreasAdminSuccess extends AreasState {
  final GetAreasAdminModel areas;

  GetAreasAdminSuccess({required this.areas});
}

final class GetAreasAdminFailure extends AreasState {
  final String message;

  GetAreasAdminFailure({required this.message});
}

// Add area
final class AddAreaLoading extends AreasState {}

final class AddAreaSuccess extends AreasState {}

final class AddAreaFailure extends AreasState {
  final String message;

  AddAreaFailure({required this.message});
}

// Edit area
final class EditAreaLoading extends AreasState {}

final class EditAreaSuccess extends AreasState {}

final class EditAreaFailure extends AreasState {
  final String message;

  EditAreaFailure({required this.message});
}

// Delete area
final class DeleteAreaLoading extends AreasState {}

final class DeleteAreaSuccess extends AreasState {}

final class DeleteAreaFailure extends AreasState {
  final String message;

  DeleteAreaFailure({required this.message});
}
