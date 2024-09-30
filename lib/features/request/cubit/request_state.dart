part of 'request_cubit.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

final class RequestImmediateLoading extends RequestState {}

final class RequestImmediateSuccess extends RequestState {}

final class RequestImmediateFailure extends RequestState {
  final String message;

  RequestImmediateFailure({required this.message});
}
