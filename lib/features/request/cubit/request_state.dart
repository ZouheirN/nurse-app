part of 'request_cubit.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

final class RequestCreateLoading extends RequestState {}

final class RequestCreateSuccess extends RequestState {}

final class RequestCreateFailure extends RequestState {
  final String message;

  RequestCreateFailure({required this.message});
}

final class RequestsHistoryLoading extends RequestState {}

final class RequestsHistorySuccess extends RequestState {
  final List<RequestsHistoryModel> requests;

  RequestsHistorySuccess({required this.requests});
}

final class RequestsHistoryFailure extends RequestState {
  final String message;

  RequestsHistoryFailure({required this.message});
}

final class RequestDetailsLoading extends RequestState {}

final class RequestDetailsSuccess extends RequestState {
  final RequestsHistoryModel request;

  RequestDetailsSuccess({required this.request});
}

final class RequestDetailsFailure extends RequestState {
  final String message;

  RequestDetailsFailure({required this.message});
}

final class RequestSubmitLoading extends RequestState {}

final class RequestSubmitSuccess extends RequestState {}

final class RequestSubmitFailure extends RequestState {
  final String message;

  RequestSubmitFailure({required this.message});
}

final class RequestSetStatusLoading extends RequestState {}

final class RequestSetStatusSuccess extends RequestState {
  final RequestsHistoryModel request;

  RequestSetStatusSuccess({required this.request});
}

final class RequestSetStatusFailure extends RequestState {
  final String message;

  RequestSetStatusFailure({required this.message});
}

final class RequestDeleteLoading extends RequestState {}

final class RequestDeleteSuccess extends RequestState {}

final class RequestDeleteFailure extends RequestState {
  final String message;

  RequestDeleteFailure({required this.message});
}