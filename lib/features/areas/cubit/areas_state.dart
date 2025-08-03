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

// Add service area price
final class AddServiceAreaPriceLoading extends AreasState {}
final class AddServiceAreaPriceSuccess extends AreasState {}
final class AddServiceAreaPriceFailure extends AreasState {
  final String message;

  AddServiceAreaPriceFailure({required this.message});
}