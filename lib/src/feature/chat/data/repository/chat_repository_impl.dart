import 'package:ai_transport/src/feature/chat/data/data_source/chat_data_source.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_list_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';
import 'package:ai_transport/src/feature/chat/domain/repository/chat_repository.dart';
import 'dart:io';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Future<ChatConversationEntity> getChatConversation(int requestId) async {
    try {
      final conversation = await _dataSource.getChatConversation(requestId);
      return conversation;
    } catch (e) {
      throw Exception('Repository error getting chat conversation: $e');
    }
  }

  @override
  Future<ChatMessageEntity> sendChatMessage({
    required int requestId,
    required String messageType,
    String? message,
    File? attachment,
    String? quickActionType,
  }) async {
    try {
      final sentMessage = await _dataSource.sendChatMessage(
        requestId: requestId,
        messageType: messageType,
        message: message,
        attachment: attachment,
        quickActionType: quickActionType,
      );
      return sentMessage;
    } catch (e) {
      throw Exception('Repository error sending chat message: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> sendChatImage({
    required int requestId,
    required File image,
    String? caption,
  }) async {
    try {
      final result = await _dataSource.sendChatImage(
        requestId: requestId,
        image: image,
        caption: caption,
      );
      return result;
    } catch (e) {
      throw Exception('Repository error sending chat image: $e');
    }
  }

  @override
  Future<ChatConversationListEntity> getAllConversations({
    String? status,
  }) async {
    try {
      final conversations = await _dataSource.getAllConversations(
        status: status,
      );
      return conversations;
    } catch (e) {
      throw Exception('Repository error getting conversations: $e');
    }
  }
}
