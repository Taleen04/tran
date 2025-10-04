import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.senderType,
    required super.senderName,
    required super.isSystem,
    required super.isRead,
    required super.type,
    required super.content,
    required super.file,
    required super.formattedTime,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as int? ?? 0,
      senderType: json["sender"]['role'] as String? ?? 'driver',
      senderName: json["sender"]['name'] as String? ?? 'client',
      isSystem: json["sender"]['is_system'] as bool? ?? false,
      isRead: json['is_read'] as bool? ?? false,
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String? ?? '',
      file: json['file'] != null ? json['file']['url'] as String? ?? '' : null,
      formattedTime: json['formatted_time'] as String? ?? "",
    );
  }

  toEntity() {
    return ChatMessageEntity(
      id: id,
      senderType: senderType,
      senderName: senderName,
      isSystem: isSystem,
      isRead: isRead,
      type: type,
      content: content,
      file: file,
      formattedTime: formattedTime,
    );
  }

}
