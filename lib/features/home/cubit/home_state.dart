part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class GetPopupsLoading extends HomeState {}

final class GetPopupsSuccess extends HomeState {
  final GetPopupsModel popups;

  GetPopupsSuccess({
    required this.popups,
  });
}

final class GetPopupsAdminSuccess extends HomeState {
  final GetPopupsAdminModel popups;

  GetPopupsAdminSuccess({
    required this.popups,
  });
}

final class GetPopupsFailure extends HomeState {
  final String message;

  GetPopupsFailure({
    required this.message,
  });
}

// Add Popup
final class AddPopupLoading extends HomeState {}
final class AddPopupSuccess extends HomeState {}
final class AddPopupFailure extends HomeState {
  final String message;

  AddPopupFailure({
    required this.message,
  });
}

// Edit Popup
final class EditPopupLoading extends HomeState {}

final class EditPopupSuccess extends HomeState {}

final class EditPopupFailure extends HomeState {
  final String message;

  EditPopupFailure({
    required this.message,
  });
}

// Get Sliders
final class GetSlidersLoading extends HomeState {}

final class GetSlidersSuccess extends HomeState {
  final GetSlidersModel sliders;

  GetSlidersSuccess({
    required this.sliders,
  });
}

final class GetSlidersFailure extends HomeState {
  final String message;

  GetSlidersFailure({
    required this.message,
  });
}

// Add Slider
final class AddSliderLoading extends HomeState {}

final class AddSliderSuccess extends HomeState {}

final class AddSliderFailure extends HomeState {
  final String message;

  AddSliderFailure({
    required this.message,
  });
}

// Delete Slider
final class DeleteSliderLoading extends HomeState {}

final class DeleteSliderSuccess extends HomeState {}

final class DeleteSliderFailure extends HomeState {
  final String message;

  DeleteSliderFailure({
    required this.message,
  });
}

// Reorder Sliders
final class ReorderSlidersLoading extends HomeState {}

final class ReorderSlidersSuccess extends HomeState {}

final class ReorderSlidersFailure extends HomeState {
  final String message;

  ReorderSlidersFailure({
    required this.message,
  });
}

// Get FAQs
final class GetFaqsLoading extends HomeState {}

final class GetFaqsSuccess extends HomeState {
  final GetFaqsModel faqs;

  GetFaqsSuccess({
    required this.faqs,
  });
}

final class GetFaqsFailure extends HomeState {
  final String message;

  GetFaqsFailure({
    required this.message,
  });
}

// Get FAQ Translation
final class GetFaqTranslationLoading extends HomeState {}

final class GetFaqTranslationSuccess extends HomeState {
  final GetFaqTranslationModel faq;

  GetFaqTranslationSuccess({
    required this.faq,
  });
}

final class GetFaqTranslationFailure extends HomeState {
  final String message;

  GetFaqTranslationFailure({
    required this.message,
  });
}

// Add FAQ
final class AddFaqLoading extends HomeState {}

final class AddFaqSuccess extends HomeState {}

final class AddFaqFailure extends HomeState {
  final String message;

  AddFaqFailure({
    required this.message,
  });
}

// Reorder FAQs
final class ReorderFaqsLoading extends HomeState {}

final class ReorderFaqsSuccess extends HomeState {}

final class ReorderFaqsFailure extends HomeState {
  final String message;

  ReorderFaqsFailure({
    required this.message,
  });
}

// Delete FAQ
final class DeleteFaqLoading extends HomeState {}

final class DeleteFaqSuccess extends HomeState {}

final class DeleteFaqFailure extends HomeState {
  final String message;

  DeleteFaqFailure({
    required this.message,
  });
}

// Edit FAQ
final class EditFaqLoading extends HomeState {}

final class EditFaqSuccess extends HomeState {}

final class EditFaqFailure extends HomeState {
  final String message;

  EditFaqFailure({
    required this.message,
  });
}

// Get Categories
final class GetCategoriesLoading extends HomeState {}

final class GetCategoriesSuccess extends HomeState {
  final GetCategoriesModel categories;

  GetCategoriesSuccess({
    required this.categories,
  });
}

final class GetCategoriesFailure extends HomeState {
  final String message;

  GetCategoriesFailure({
    required this.message,
  });
}

// Add Category
final class AddCategoryLoading extends HomeState {}

final class AddCategorySuccess extends HomeState {}

final class AddCategoryFailure extends HomeState {
  final String message;

  AddCategoryFailure({
    required this.message,
  });
}

// Get Dashboard
final class GetDashboardLoading extends HomeState {}

final class GetDashboardSuccess extends HomeState {
  final GetDashboardModel dashboard;

  GetDashboardSuccess({
    required this.dashboard,
  });
}

final class GetDashboardFailure extends HomeState {
  final String message;

  GetDashboardFailure({
    required this.message,
  });
}
