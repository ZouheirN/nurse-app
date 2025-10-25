import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/home/models/get_faq_translation_model.dart';
import 'package:nurse_app/features/home/models/get_popups_admin.dart';
import 'package:nurse_app/features/home/models/get_popups_model.dart';
import 'package:nurse_app/utilities/localization_box.dart';

import '../../../main.dart';
import '../../../services/user_token.dart';
import '../models/get_categories_model.dart';
import '../models/get_dashboard_model.dart';
import '../models/get_faqs_model.dart';
import '../models/get_sliders_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getDashboard() async {
    emit(GetDashboardLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/user/dashboard',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final dashboard = GetDashboardModel.fromJson(response.data);

      emit(GetDashboardSuccess(dashboard: dashboard));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetDashboardFailure(
          message: e.response?.data['message'] ?? 'Failed to get dashboard.'));
    } catch (e) {
      logger.e(e);
      emit(GetDashboardFailure(message: 'Failed to get dashboard.'));
    }
  }

  Future<void> getPopups() async {
    emit(GetPopupsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/popups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final popups = GetPopupsModel.fromJson(response.data);

      emit(GetPopupsSuccess(popups: popups));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetPopupsFailure(
          message: e.response?.data['message'] ?? 'Failed to get popups.'));
    } catch (e) {
      logger.e(e);
      emit(GetPopupsFailure(message: 'Failed to get popups.'));
    }
  }

  Future<void> getPopupsAdmin() async {
    emit(GetPopupsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/admin/popups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final popups = GetPopupsAdminModel.fromJson(response.data);

      emit(GetPopupsAdminSuccess(popups: popups));
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(GetPopupsFailure(
          message: e.response?.data['message'] ?? 'Failed to get popups.'));
    } catch (e) {
      logger.e(e);
      emit(GetPopupsFailure(message: 'Failed to get popups.'));
    }
  }

  Future<void> addPopup({
    required XFile? pickedFile,
    required String title,
    required String content,
    required String type,
  }) async {
    emit(AddPopupLoading());

    final formData = FormData.fromMap({
      if (pickedFile != null)
        'image': await MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.name,
        ),
      'title': title,
      'content': content,
      'type': type,
    });

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/popups',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(AddPopupSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(AddPopupFailure(
          message: e.response?.data['message'] ?? 'Failed to add slider.'));
    } catch (e) {
      logger.e('Error creating popup: $e');
      emit(AddPopupFailure(message: 'Failed to add slider.'));
    }
  }

  Future<void> editPopup({
    required String id,
    required String title,
    required String content,
    required String type,
    required DateTime? startDate,
    required DateTime? endDate,
    required bool isActive,
  }) async {
    emit(EditPopupLoading());

    try {
      final token = await UserToken.getToken();

      await dio.put(
        '$HOST/admin/popups/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'title': title,
          'content': content,
          'type': type,
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'is_active': isActive,
        },
      );

      emit(EditPopupSuccess());
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(EditPopupFailure(
          message: e.response!.data['message'] ?? 'Failed to edit popup.'));
    } catch (e) {
      logger.e(e);
      emit(EditPopupFailure(message: 'Failed to edit popup.'));
    }
  }

  Future<void> getSliders({
    bool isAdmin = false,
  }) async {
    emit(GetSlidersLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        isAdmin ? '$HOST/admin/sliders' : '$HOST/sliders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final sliders = GetSlidersModel.fromJson(response.data);

      emit(GetSlidersSuccess(sliders: sliders));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      logger.e(e.response!.statusCode);
      emit(GetSlidersFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetSlidersFailure(message: 'Failed to get popups.'));
    }
  }

  Future<void> addSlider({
    required XFile pickedFile,
    required String title,
    required String subtitle,
    required int position,
  }) async {
    emit(AddSliderLoading());

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        pickedFile.path,
        filename: pickedFile.name,
      ),
      'title': title,
      'subtitle': subtitle,
      'position': position,
    });

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/sliders',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(AddSliderSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      logger.e(e.response?.data);
      emit(AddSliderFailure(
          message: e.response?.data['message'] ?? 'Failed to add slider.'));
    } catch (e) {
      logger.e('Error creating popup: $e');
      emit(AddSliderFailure(message: 'Failed to add slider.'));
    }
  }

  Future<void> deleteSlider(int id) async {
    emit(DeleteSliderLoading());

    final token = await UserToken.getToken();

    try {
      await dio.delete(
        '$HOST/admin/sliders/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(DeleteSliderSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(DeleteSliderFailure(
          message: e.response?.data['message'] ?? 'Failed to delete slider.'));
    } catch (e) {
      logger.e('Error deleting slider: $e');
      emit(DeleteSliderFailure(message: 'Failed to delete slider.'));
    }
  }

  Future<void> reorderSliders(List<int> newOrder) async {
    emit(ReorderSlidersLoading());

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/sliders/reorder',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: {
          'slider_ids': newOrder,
        },
      );

      emit(ReorderSlidersSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(ReorderSlidersFailure(
          message:
              e.response?.data['message'] ?? 'Failed to reorder sliders.'));
    } catch (e) {
      logger.e('Error reordering slider: $e');
      emit(ReorderSlidersFailure(message: 'Failed to reorder sliders.'));
    }
  }

  Future<void> getFaqs({required bool isAdmin}) async {
    emit(GetFaqsLoading());

    try {
      final token = await UserToken.getToken();

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      if (!isAdmin) {
        headers['Accept-Language'] = 'en';

        final locale = LocalizationBox.getLocale();

        if (locale != null) {
          headers['Accept-Language'] = locale.languageCode;
        }
      }

      final response = await dio.get(
        isAdmin ? '$HOST/admin/faqs' : '$HOST/faqs',
        options: Options(
          headers: headers,
        ),
      );

      logger.i(response.data);

      final faqs = GetFaqsModel.fromJson(response.data);

      emit(GetFaqsSuccess(faqs: faqs));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetFaqsFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetFaqsFailure(message: 'Failed to get faqs.'));
    }
  }

  Future<void> getFaqTranslation(int faqId) async {
    emit(GetFaqTranslationLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/admin/faqs/$faqId/translations',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final faq = GetFaqTranslationModel.fromJson(response.data);

      emit(GetFaqTranslationSuccess(faq: faq));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetFaqTranslationFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetFaqTranslationFailure(message: 'Failed to get faqs.'));
    }
  }

  Future<void> addFaq({
    required String question,
    required String answer,
    required int order,
  }) async {
    emit(AddFaqLoading());

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/faqs',
        data: {
          'question': question,
          'answer': answer,
          'order': order,
          'is_active': true,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(AddFaqSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(AddFaqFailure(
          message: e.response?.data['message'] ?? 'Failed to add FAQ.'));
    } catch (e) {
      logger.e('Error adding FAQ: $e');
      emit(AddFaqFailure(message: 'Failed to add FAQ.'));
    }
  }

  Future<void> addFaqTranslation({
    required int faqId,
    required String question,
    required String answer,
  }) async {
    emit(AddFaqLoading());

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/faqs/$faqId/translations',
        data: {
          'question': question,
          'answer': answer,
          'locale': 'ar',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(AddFaqSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(AddFaqFailure(
          message:
              e.response?.data['message'] ?? 'Failed to add FAQ translation.'));
    } catch (e) {
      logger.e('Error adding FAQ: $e');
      emit(AddFaqFailure(message: 'Failed to add FAQ translation.'));
    }
  }

  Future<void> editFaqTranslation({
    required int faqId,
    required String question,
    required String answer,
  }) async {
    emit(EditFaqLoading());

    final token = await UserToken.getToken();

    try {
      await dio.put(
        '$HOST/admin/faqs/$faqId/translations/ar',
        data: {
          'question': question,
          'answer': answer,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(EditFaqSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(EditFaqFailure(
          message: e.response?.data['message'] ??
              'Failed to edit FAQ translation.'));
    } catch (e) {
      logger.e('Error adding FAQ: $e');
      emit(EditFaqFailure(message: 'Failed to edit FAQ translation.'));
    }
  }

  Future<void> reorderFaq(List<int> newOrder) async {
    emit(ReorderFaqsLoading());

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/faqs/reorder',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: {'faq_ids': newOrder},
      );

      emit(ReorderFaqsSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(ReorderFaqsFailure(
          message: e.response?.data['message'] ?? 'Failed to reorder FAQs.'));
    } catch (e) {
      logger.e('Error reordering FAQs: $e');
      emit(ReorderFaqsFailure(message: 'Failed to reorder FAQs.'));
    }
  }

  Future<void> deleteFaq(int id) async {
    emit(DeleteFaqLoading());

    final token = await UserToken.getToken();

    try {
      await dio.delete(
        '$HOST/admin/faqs/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(DeleteFaqSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(DeleteFaqFailure(
          message: e.response?.data['message'] ?? 'Failed to delete FAQ.'));
    } catch (e) {
      logger.e('Error deleting FAQ: $e');
      emit(DeleteFaqFailure(message: 'Failed to delete FAQ.'));
    }
  }

  Future<void> editFaq({
    required int id,
    required String question,
    required String answer,
    required int order,
    required bool isActive,
  }) async {
    emit(EditFaqLoading());

    final token = await UserToken.getToken();

    try {
      await dio.put(
        '$HOST/admin/faqs/$id',
        data: {
          'question': question,
          'answer': answer,
          'order': order,
          'is_active': isActive,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(EditFaqSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(EditFaqFailure(
          message: e.response?.data['message'] ?? 'Failed to edit FAQ.'));
    } catch (e) {
      logger.e('Error editing FAQ: $e');
      emit(EditFaqFailure(message: 'Failed to edit FAQ.'));
    }
  }

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/categories',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      final categories = GetCategoriesModel.fromJson(response.data);

      emit(GetCategoriesSuccess(categories: categories));
    } on DioException catch (e) {
      logger.e(e.response!.data);
      emit(GetCategoriesFailure(
          message: e.response?.data['message'] ?? 'Failed to get categories.'));
    } catch (e) {
      logger.e(e);
      emit(GetCategoriesFailure(message: 'Failed to get categories.'));
    }
  }

  Future<void> addCategory({
    required String name,
    required File imageFile,
  }) async {
    emit(AddCategoryLoading());

    final token = await UserToken.getToken();

    try {
      final formData = FormData.fromMap({
        'name': name,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: name,
        ),
      });

      await dio.post(
        '$HOST/admin/categories',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(AddCategorySuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      logger.e(e.response?.data);
      emit(AddCategoryFailure(
          message: e.response?.data['message'] ?? 'Failed to add category.'));
    } catch (e) {
      logger.e('Error adding category: $e');
      emit(AddCategoryFailure(message: 'Failed to add category.'));
    }
  }
}
