import 'dart:io';

import '../../domain/entities/chat_message_entity.dart';

abstract class ChatEvent {}

class GetChatConversationEvent extends ChatEvent {
  final int requestId;

  GetChatConversationEvent(this.requestId);
}

class SendChatMessageEvent extends ChatEvent {
  final int requestId;
  final String messageType;
  final String? message;
  final File? attachment;
  final String? quickActionType;

  SendChatMessageEvent({
    required this.requestId,
    required this.messageType,
    this.message,
    this.attachment,
    this.quickActionType,
  });
}

class SendChatImageEvent extends ChatEvent {
  final int requestId;
  final File image;
  final String? caption;

  SendChatImageEvent({
    required this.requestId,
    required this.image,
    this.caption,
  });
}

class GetAllConversationsEvent extends ChatEvent {
  final String? status;

  GetAllConversationsEvent({this.status});
}

class AddNewMessageEvent extends ChatEvent {
  final dynamic message;

  AddNewMessageEvent(this.message);
}

class MarkMessageAsReadEvent extends ChatEvent {
  final int messageId;

  MarkMessageAsReadEvent(this.messageId);
}

class InitializePusherEvent extends ChatEvent {
  final int? conversationId;

  InitializePusherEvent({this.conversationId});
}

class DisposePusherEvent extends ChatEvent {
  DisposePusherEvent();
}

class PusherMessageReceived extends ChatEvent {
  final ChatMessageEntity message;
  PusherMessageReceived(this.message);
}
