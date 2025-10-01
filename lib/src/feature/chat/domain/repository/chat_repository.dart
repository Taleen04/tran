import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_list_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';
import 'dart:io';

abstract class ChatRepository {
  Future<ChatConversationEntity> getChatConversation(int requestId);
  Future<ChatMessageEntity> sendChatMessage({
    required int requestId,
    required String messageType,
    String? message,
    File? attachment,
    String? quickActionType,
  });
  Future<Map<String, dynamic>> sendChatImage({
    required int requestId,
    required File image,
    String? caption,
  });
  Future<ChatConversationListEntity> getAllConversations({String? status});
}
