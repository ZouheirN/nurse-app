import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    emit(LocationUpdateLoading());

    try {
      final token = await UserToken.getToken();

      final response = await http.post(
        Uri.parse('$HOST/submit-location'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(LocationUpdateSuccess());
      } else {
        emit(LocationUpdateFailure(
            message: jsonData['message'] ??
                'An error occurred. Please check your connection and try again later.'));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(LocationUpdateFailure(
          message:
              'An error occurred. Please check your connection and try again later.'));
    }
  }
}
