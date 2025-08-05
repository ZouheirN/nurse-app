part of 'about_us_cubit.dart';

@immutable
sealed class AboutUsState {}

final class AboutUsInitial extends AboutUsState {}

final class AboutUsFetchLoading extends AboutUsState {}

final class AboutUsFetchSuccess extends AboutUsState {
  final Map aboutUs;

  AboutUsFetchSuccess({required this.aboutUs});
}

final class AboutUsFetchFailure extends AboutUsState {
  final String message;

  AboutUsFetchFailure({required this.message});
}

final class AboutUsUpdateLoading extends AboutUsState {}

final class AboutUsUpdateSuccess extends AboutUsState {
  final Map aboutUs;

  AboutUsUpdateSuccess({required this.aboutUs});
}

final class AboutUsUpdateFailure extends AboutUsState {
  final String message;

  AboutUsUpdateFailure({required this.message});
}

// Submit contact form
final class SubmitContactFormLoading extends AboutUsState {}

final class SubmitContactFormSuccess extends AboutUsState {}

final class SubmitContactFormFailure extends AboutUsState {
  final String message;

  SubmitContactFormFailure({required this.message});
}

// Get contact forms
final class GetContactFormsLoading extends AboutUsState {}
final class GetContactFormsSuccess extends AboutUsState {
  final GetContactFormsModel contactForms;

  GetContactFormsSuccess({required this.contactForms});
}
final class GetContactFormsFailure extends AboutUsState {
  final String message;

  GetContactFormsFailure({required this.message});
}

// Delete contact form
final class DeleteContactFormLoading extends AboutUsState {}
final class DeleteContactFormSuccess extends AboutUsState {}
final class DeleteContactFormFailure extends AboutUsState {
  final String message;

  DeleteContactFormFailure({required this.message});
}