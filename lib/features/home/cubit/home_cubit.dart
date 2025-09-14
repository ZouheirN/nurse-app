import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/home/models/get_popups_model.dart';

import '../../../main.dart';
import '../../../services/user_token.dart';
import '../models/get_faqs_model.dart';
import '../models/get_sliders_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

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
      emit(GetPopupsFailure(message: e.response!.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetPopupsFailure(message: 'Failed to get popups.'));
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

  Future<void> reorderSlider(int id, int newPosition) async {
    emit(ReorderSlidersLoading());

    final token = await UserToken.getToken();

    try {
      await dio.put(
        '$HOST/admin/sliders/$id',
        data: {'position': newPosition},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      emit(ReorderSlidersSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.statusCode);
      emit(ReorderSlidersFailure(
          message: e.response?.data['message'] ?? 'Failed to reorder slider.'));
    } catch (e) {
      logger.e('Error reordering slider: $e');
      emit(ReorderSlidersFailure(message: 'Failed to reorder slider.'));
    }
  }

  Future<void> getFaqs() async {
    emit(GetFaqsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/admin/faqs',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

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

  Future<void> reorderFaq(List<int> newOrder) async {
    emit(ReorderFaqsLoading());

    final token = await UserToken.getToken();

    try {
      await dio.post(
        '$HOST/admin/faqs/reorder',
        data: {'faq_ids': newOrder},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
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
}
