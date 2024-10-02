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