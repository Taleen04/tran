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

}


class ChatConversationListItemModel extends ChatConversationListItemEntity {
  ChatConversationListItemModel({
    required super.id,
    required super.requestId,
    required super.participants,
    required super.status,
    required super.activity,
    required super.unreadCount,
  });

  factory ChatConversationListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationListItemModel(
      id: json['id'] as int,
      requestId: json['request_id'] as int,
      participants: Participants.fromJson(json['participants']),
      status: Status.fromJson(json['status']),
      activity: Activity.fromJson(json['activity']),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

}

