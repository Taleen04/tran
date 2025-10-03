class ChatMessageEntity {
  final int id;
  final String senderType; // 'transport_staff' or 'client'
  final String senderName;
  final bool isSystem,isRead;
  final String type; // 'text', 'image', 'voice', 'quick_action'
  final String? content;
  final String? file;
  final String formattedTime;

  ChatMessageEntity({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.isRead,
    required this.isSystem,
    required this.type,
    required this.content,
    required this.file,
    required this.formattedTime,

  });
}
