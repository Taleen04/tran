import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.senderType,
    required super.senderId,
    required super.senderName,
    required super.messageType,
    super.message,
    super.attachmentUrl,
    super.quickActionType,
    required super.isRead,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int? ?? 0,
      conversationId: json['conversation_id'] as int? ?? 0,
      senderType: json['sender_type'] as String? ?? 'user',
      senderId: json['sender_id'] as int? ?? 0,
      senderName: json['sender_name'] as String? ?? 'مستخدم',
      messageType: json['message_type'] as String? ?? 'text',
      message: json['message'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
      quickActionType: json['quick_action_type'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_type': senderType,
      'sender_id': senderId,
      'sender_name': senderName,
      'message_type': messageType,
      'message': message,
      'attachment_url': attachmentUrl,
      'quick_action_type': quickActionType,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
