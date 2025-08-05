import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/features/about_us/models/get_contact_forms_model.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

part 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() : super(AboutUsInitial());

  Future<void> fetchAboutUs() async {
    emit(AboutUsFetchLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/about',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(AboutUsFetchSuccess(aboutUs: response.data['about']));
    } catch (e) {
      logger.e(e);
      emit(AboutUsFetchFailure(message: 'Failed to fetch about us.'));
    }
  }

  Future<void> updateAboutUs({
    required String website,
    required String instagram,
    required String facebook,
    required String tiktok,
    required List<String> whatsapp,
  }) async {
    emit(AboutUsUpdateLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.put(
        '$HOST/admin/about',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'online_shop_url': website,
          'instagram_url': instagram,
          'facebook_url': facebook,
          'tiktok_url': tiktok,
          'whatsapp_number': whatsapp,
        },
      );

      emit(AboutUsUpdateSuccess(aboutUs: response.data['about']));
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(AboutUsUpdateFailure(message: e.response?.data['message']));
    } catch (e) {
      logger.e(e);
      emit(AboutUsUpdateFailure(message: 'Failed to update about us.'));
    }
  }

  Future<void> submitContactForm({
    required String firstName,
    required String lastName,
    required String address,
    required String description,
    required String phoneNumber,
  }) async {
    emit(SubmitContactFormLoading());

    try {
      final token = await UserToken.getToken();

      await dio.post(
        '$HOST/contact',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'first_name': firstName,
          'second_name': lastName,
          'address': address,
          'description': description,
          'phone_number': phoneNumber,
        },
      );

      emit(SubmitContactFormSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(SubmitContactFormFailure(
          message:
              e.response?.data['message'] ?? 'Failed to submit contact form.'),);
    } catch (e) {
      logger.e(e);
      emit(SubmitContactFormFailure(message: 'Failed to submit contact form.'));
    }
  }

  Future<void> getContactForms() async {
    emit(GetContactFormsLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.get(
        '$HOST/admin/contacts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final contactForms = GetContactFormsModel.fromJson(response.data);

      emit(GetContactFormsSuccess(contactForms: contactForms));
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(GetContactFormsFailure(message: e.response?.data['message']));
    } catch (e) {
      logger.e(e);
      emit(GetContactFormsFailure(message: 'Failed to fetch contact forms.'));
    }
  }

  Future<void> deleteContactForm(int id) async {
    emit(DeleteContactFormLoading());

    try {
      final token = await UserToken.getToken();

      await dio.delete(
        '$HOST/admin/contacts/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      emit(DeleteContactFormSuccess());
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(DeleteContactFormFailure(message: e.response?.data['message']));
    } catch (e) {
      logger.e(e);
      emit(DeleteContactFormFailure(message: 'Failed to delete contact form.'));
    }
  }
}
