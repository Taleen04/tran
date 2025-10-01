class ChatMessageEntity {
  final int id;
  final int conversationId;
  final String senderType; // 'transport_staff' or 'client'
  final int senderId;
  final String senderName;
  final String messageType; // 'text', 'image', 'voice', 'quick_action'
  final String? message;
  final String? attachmentUrl;
  final String? quickActionType; // 'call', 'whatsapp', 'help'
  final bool isRead;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    required this.messageType,
    this.message,
    this.attachmentUrl,
    this.quickActionType,
    required this.isRead,
    required this.createdAt,
  });
}
