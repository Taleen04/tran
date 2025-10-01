class ChatConversationListItemEntity {
  final int requestId;
  final String clientName;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final String requestStatus;

  ChatConversationListItemEntity({
    required this.requestId,
    required this.clientName,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.requestStatus,
  });
}

class ChatConversationListEntity {
  final List<ChatConversationListItemEntity> conversations;

  ChatConversationListEntity({required this.conversations});
}
