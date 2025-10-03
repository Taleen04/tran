class ChatConversationListItemEntity {
  final int id;
  final int requestId;
  final Participants participants;
  final Status status;
  final Activity activity;
  final int unreadCount;

  ChatConversationListItemEntity({
    required this.id,
    required this.requestId,
    required this.participants,
    required this.status,
    required this.activity,
    required this.unreadCount,
  });

  factory ChatConversationListItemEntity.fromJson(Map<String, dynamic> json) {
    return ChatConversationListItemEntity(
      id: json['id'],
      requestId: json['request_id'],
      participants: Participants.fromJson(json['participants']),
      status: Status.fromJson(json['status']),
      activity: Activity.fromJson(json['activity']),
      unreadCount: json['unread_count'],
    );
  }
}

class Participants {
  final User driver;
  final User client;

  Participants({required this.driver, required this.client});

  factory Participants.fromJson(Map<String, dynamic> json) {
    return Participants(
      driver: User.fromJson(json['driver']),
      client: User.fromJson(json['client']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String phone;
  final String? photo;

  User({required this.id, required this.name, required this.phone,required this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      photo: json['photo_link'],
    );
  }
}

class Status {
  final bool isActive;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String duration;
  final int participantCount;

  Status({
    required this.isActive,
    required this.startedAt,
    this.endedAt,
    required this.duration,
    required this.participantCount,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      isActive: json['is_active'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null ? DateTime.tryParse(json['ended_at']) : null,
      duration: json['duration'],
      participantCount: json['participant_count'],
    );
  }
}

class Activity {
  final int totalMessages;
  final DateTime lastActivity;
  final bool isStale;
  final String? lastMessage;

  Activity({
    required this.totalMessages,
    required this.lastActivity,
    required this.isStale,
    this.lastMessage,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      totalMessages: json['total_messages'],
      lastActivity: DateTime.parse(json['last_activity']),
      isStale: json['is_stale'],
      lastMessage:json['last_message'] !=  null ? json['last_message']["content"] : null,
    );
  }
}

class ChatConversationListEntity {
  final List<ChatConversationListItemEntity> conversations;

  ChatConversationListEntity({required this.conversations});

  factory ChatConversationListEntity.fromJson(List<dynamic> jsonList) {
    return ChatConversationListEntity(
      conversations: jsonList
          .map((e) => ChatConversationListItemEntity.fromJson(e))
          .toList(),
    );
  }
}
