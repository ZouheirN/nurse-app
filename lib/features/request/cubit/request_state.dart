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
