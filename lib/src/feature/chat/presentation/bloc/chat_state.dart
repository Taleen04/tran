import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_list_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';

import '../../data/models/chat_message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatConversationLoaded extends ChatState {
  final ChatConversationEntity conversation;

  ChatConversationLoaded(this.conversation);
}

class ChatConversationListLoaded extends ChatState {
  final ChatConversationListEntity conversations;

  ChatConversationListLoaded(this.conversations);
}

class ChatMessageSent extends ChatState {
  final ChatMessageEntity message;

  ChatMessageSent(this.message);
}

class PusherSend extends ChatState {}

class ChatImageSent extends ChatState {
  final ChatMessageModel result;

  ChatImageSent(this.result);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

