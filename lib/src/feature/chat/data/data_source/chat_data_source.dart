import 'dart:io';
import 'package:ai_transport/src/core/database/api/apiclient.dart';
import 'package:ai_transport/src/core/resources/api_constants.dart';
import 'package:ai_transport/src/feature/chat/data/models/chat_conversation_model.dart';
import 'package:ai_transport/src/feature/chat/data/models/chat_conversation_list_model.dart';
import 'package:ai_transport/src/feature/chat/data/models/chat_message_model.dart';
import 'package:ai_transport/src/feature/chat/data/services/pusher_service.dart';
import 'package:dio/dio.dart';

abstract class ChatDataSource {
  Future<ChatConversationModel> getChatConversation(int requestId);
  Future<ChatMessageModel> sendChatMessage({
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
  Future<ChatConversationListModel> getAllConversations({String? status});
}

class ChatDataSourceImpl implements ChatDataSource {
  final Dio _dio = ApiClient.dio;

  @override
  Future<ChatConversationModel> getChatConversation(int requestId) async {
    try {
      final response = await _dio.get(
        ApiConstants.getChatConversation(requestId),
      );

      if (response.statusCode == 200) {
        return ChatConversationModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to get chat conversation: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting chat conversation: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendChatMessage({
    required int requestId,
    required String messageType,
    String? message,
    List<File>? attachments,
    String? quickActionType,
  }) async {
    try {
      FormData formData = FormData();

      formData.fields.add(MapEntry('message_type', messageType));

      if (message != null && message.isNotEmpty) {
        formData.fields.add(MapEntry('message', message));
      }

      if (attachments != null) {
        formData.files.add(
          MapEntry('attachments', await MultipartFile.fromFile(attachments.first.path)),
        );
      }

      if (quickActionType != null && quickActionType.isNotEmpty) {
        formData.fields.add(MapEntry('quick_action_type', quickActionType));
      }

      final response = await _dio.post(
        ApiConstants.sendChatMessage(requestId),
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        final messageModel = ChatMessageModel.fromJson(response.data['data']["message"]);


        return messageModel;
      } else {
        throw Exception('Failed to send chat message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending chat message: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendChatImage({
    required int requestId,
    required File image,
    String? caption,
  }) async {
    try {
      FormData formData = FormData();

      formData.files.add(
        MapEntry('image', await MultipartFile.fromFile(image.path)),
      );

      if (caption != null && caption.isNotEmpty) {
        formData.fields.add(MapEntry('caption', caption));
      }

      final response = await _dio.post(
        ApiConstants.sendChatImage(requestId),
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        return ChatMessageModel.fromJson(response.data['data']["message"]);
      } else {
        throw Exception('Failed to send chat image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending chat image: $e');
    }
  }

  @override
  Future<ChatConversationListModel> getAllConversations({
    String? status,
  }) async {
    try {
      String url = ApiConstants.getAllConversations;
      if (status != null) {
        url += '?status=$status';
      }

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return ChatConversationListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get conversations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting conversations: $e');
    }
  }

}
