import 'package:ai_transport/src/feature/chat/domain/entities/chat_conversation_list_entity.dart';

class ChatConversationListModel extends ChatConversationListEntity {
  ChatConversationListModel({required super.conversations});

  factory ChatConversationListModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return ChatConversationListModel(
      conversations:
          (data['conversations'] as List)
              .map(
                (conversation) => ChatConversationListItemModel.fromJson(
                  conversation as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'conversations':
            conversations
                .map(
                  (conversation) =>
                      (conversation as ChatConversationListItemModel).toJson(),
                )
                .toList(),
      },
    };
  }
}

class ChatConversationListItemModel extends ChatConversationListItemEntity {
  ChatConversationListItemModel({
    required super.requestId,
    required super.clientName,
    required super.lastMessage,
    required super.lastMessageAt,
    required super.unreadCount,
    required super.requestStatus,
  });

  factory ChatConversationListItemModel.fromJson(Map<String, dynamic> json) {
    // Extract client name from participants
    final participants = json['participants'] as Map<String, dynamic>?;
    final client = participants?['client'] as Map<String, dynamic>?;
    final clientName = client?['name'] as String? ?? 'عميل';

    // Extract last activity from activity object
    final activity = json['activity'] as Map<String, dynamic>?;
    final lastActivity = activity?['last_activity'] as String?;
    final lastMessageAt =
        lastActivity != null ? DateTime.parse(lastActivity) : DateTime.now();

    return ChatConversationListItemModel(
      requestId: json['request_id'] as int,
      clientName: clientName,
      lastMessage:
          'لا توجد رسائل', // Default message since API doesn't provide last message
      lastMessageAt: lastMessageAt,
      unreadCount: json['unread_count'] as int? ?? 0,
      requestStatus:
          'active', // Default status since API doesn't provide request status
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'client_name': clientName,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt.toIso8601String(),
      'unread_count': unreadCount,
      'request_status': requestStatus,
    };
  }
}
