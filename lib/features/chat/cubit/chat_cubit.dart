import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nurse_app/features/chat/models/get_messages_model.dart';
import 'package:nurse_app/services/user.dart';
import 'package:nurse_app/services/user_token.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../consts.dart';
import '../../../main.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  Future<void> initializeChat(int requestId) async {
    emit(ChatLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.post(
        '$HOST/requests/$requestId/chat/open',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final chatId = response.data['data']['threadId'];

      final channel = WebSocketChannel.connect(
        Uri.parse('wss://$HOST/chat/threads/$chatId/messages'),
        protocols: ['Bearer', token!],
      );

      emit(ChatLoaded(
        chatId,
        channel,
      ));
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(ChatError(
          e.response?.data['message'] ?? 'Failed to initialize chat'));
    } catch (e) {
      logger.e(e.toString());
      emit(ChatError('An unexpected error occurred'));
    }
  }

  Future<void> getMessages({
    required int chatId,
    int? cursor,
  }) async {
    emit(MessagesLoading());

    try {
      final token = await UserToken.getToken();

      final queryParams = {
        'limit': 50,
      };

      if (cursor != null) {
        queryParams['cursor'] = cursor;
      }

      final response = await dio.get(
        '$HOST/chat/threads/$chatId/messages',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final messages = GetMessagesModel.fromJson(response.data);

      emit(MessagesLoaded(messages));
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(MessagesError(
          e.response?.data['message'] ?? 'Failed to get messages'));
    } catch (e) {
      logger.e(e.toString());
      emit(MessagesError('An unexpected error occurred'));
    }
  }

  Future<void> sendTextMessage({
    required String text,
    required int chatId,
  }) async {
    emit(SendMessageLoading());

    try {
      final token = await UserToken.getToken();

      final response = await dio.post(
        '$HOST/chat/threads/$chatId/messages',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        data: {
          'type': 'text',
          'text': text,
        },
      );

      final senderId = UserBox.getUser()!.id;

      emit(
        SendMessageSuccess(
          Message(
            id: response.data['data']['id'],
            type: 'text',
            text: text,
            createdAt: DateTime.now(),
            lat: null,
            lng: null,
            mediaUrl: null,
            senderId: senderId!.toInt(),
          ),
        ),
      );
    } on DioException catch (e) {
      logger.e(e.response?.data);
      emit(SendMessageError(
          e.response?.data['message'] ?? 'Failed to send message'));
    } catch (e) {
      logger.e(e.toString());
      emit(SendMessageError('An unexpected error occurred'));
    }
  }
}
