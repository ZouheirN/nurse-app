part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

// Initialize Chat
final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final int chatId;
  final WebSocketChannel channel;

  ChatLoaded(this.chatId, this.channel);
}

final class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

// Get Messages
final class MessagesLoading extends ChatState {}

final class MessagesLoaded extends ChatState {
  final GetMessagesModel messages;

  MessagesLoaded(this.messages);
}

final class MessagesError extends ChatState {
  final String message;

  MessagesError(this.message);
}

// Send Message
final class SendMessageLoading extends ChatState {}

final class SendMessageSuccess extends ChatState {
  final Message message;

  SendMessageSuccess(this.message);
}

final class SendMessageError extends ChatState {
  final String message;

  SendMessageError(this.message);
}
