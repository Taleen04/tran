import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_list_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';
import 'dart:io';

import '../../data/models/chat_message_model.dart';

abstract class ChatRepository {
  Future<ChatConversationEntity> getChatConversation(int requestId);
  Future<ChatMessageEntity> sendChatMessage({
    required int requestId,
    required String messageType,
    String? message,
    List<File>? attachments,
    String? quickActionType,
  });
  Future<ChatMessageModel> sendChatImage({
    required int requestId,
    required File image,
    String? caption,
  });
  Future<ChatConversationListEntity> getAllConversations({String? status});
}
