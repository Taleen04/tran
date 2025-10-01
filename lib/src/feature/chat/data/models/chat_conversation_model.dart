import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_entity.dart';
import 'chat_message_model.dart';

class ChatConversationModel extends ChatConversationEntity {
  ChatConversationModel({
    required super.conversationId,
    required super.unreadCount,
    required super.messages,
    required super.clientInfo,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    // Handle messages - might be null or empty
    final messagesData = data['messages'] as List? ?? [];
    final messages =
        messagesData
            .map(
              (message) =>
                  ChatMessageModel.fromJson(message as Map<String, dynamic>),
            )
            .toList();

    // Handle client info - might be in different structure
    final clientInfoData =
        data['client_info'] as Map<String, dynamic>? ??
        data['participants']?['client'] as Map<String, dynamic>?;

    final clientInfo =
        clientInfoData != null
            ? ClientInfoModel.fromJson(clientInfoData)
            : ClientInfoModel(name: 'عميل', phone: '');

    return ChatConversationModel(
      conversationId:
          data['conversation_id'] as int? ?? data['id'] as int? ?? 0,
      unreadCount: data['unread_count'] as int? ?? 0,
      messages: messages,
      clientInfo: clientInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'conversation_id': conversationId,
        'unread_count': unreadCount,
        'messages':
            messages
                .map((message) => (message as ChatMessageModel).toJson())
                .toList(),
        'client_info': (clientInfo as ClientInfoModel).toJson(),
      },
    };
  }
}

class ClientInfoModel extends ClientInfoEntity {
  ClientInfoModel({required super.name, required super.phone});

  factory ClientInfoModel.fromJson(Map<String, dynamic> json) {
    return ClientInfoModel(
      name: json['name'] as String? ?? 'عميل',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }
}
