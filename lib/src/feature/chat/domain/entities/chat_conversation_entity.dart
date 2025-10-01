import 'chat_message_entity.dart';

class ChatConversationEntity {
  final int conversationId;
  final int unreadCount;
  final List<ChatMessageEntity> messages;
  final ClientInfoEntity clientInfo;

  ChatConversationEntity({
    required this.conversationId,
    required this.unreadCount,
    required this.messages,
    required this.clientInfo,
  });
}

class ClientInfoEntity {
  final String name;
  final String phone;

  ClientInfoEntity({required this.name, required this.phone});
}
