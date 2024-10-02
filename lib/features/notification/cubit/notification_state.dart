part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationSendLoading extends NotificationState {}

final class NotificationSendSuccess extends NotificationState {}

final class NotificationSendFailure extends NotificationState {
  final String message;

  NotificationSendFailure({required this.message});
}