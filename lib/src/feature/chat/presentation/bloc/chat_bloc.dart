import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/get_chat_conversation_usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/send_chat_image_usecase.dart';
import 'package:ai_transport/src/feature/chat/domain/usecases/get_all_conversations_usecase.dart';
import 'package:ai_transport/src/feature/chat/presentation/bloc/chat_event.dart';
import 'package:ai_transport/src/feature/chat/presentation/bloc/chat_state.dart';
import 'package:ai_transport/src/feature/chat/data/services/pusher_service.dart';
import 'package:ai_transport/src/feature/chat/domain/entities/chat_message_entity.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../data/models/chat_message_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatConversationUseCase _getChatConversationUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final SendChatImageUseCase _sendChatImageUseCase;
  final GetAllConversationsUseCase _getAllConversationsUseCase;
  final PusherService _pusherService;

  ChatBloc({
    required GetChatConversationUseCase getChatConversationUseCase,
    required SendChatMessageUseCase sendChatMessageUseCase,
    required SendChatImageUseCase sendChatImageUseCase,
    required GetAllConversationsUseCase getAllConversationsUseCase,
    required PusherService pusherService,
  }) : _getChatConversationUseCase = getChatConversationUseCase,
       _sendChatMessageUseCase = sendChatMessageUseCase,
       _sendChatImageUseCase = sendChatImageUseCase,
       _getAllConversationsUseCase = getAllConversationsUseCase,
       _pusherService = pusherService,
       super(ChatInitial()) {
    on<GetChatConversationEvent>(_onGetChatConversation);
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<GetAllConversationsEvent>(_onGetAllConversations);

    on<MarkMessageAsReadEvent>(_onMarkMessageAsRead);
    on<InitializePusherEvent>(initPusher);
    on<PusherMessageReceived>((event, emit) {
      messages.add(event.message);
      emit(PusherSend()); // or a richer state if you want
    });
    on<DisposePusherEvent>(disposePusher);
  }

  Future<void> _onGetChatConversation(
    GetChatConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversation = await _getChatConversationUseCase(event.requestId);
      messages.addAll(conversation.messages);
      emit(ChatConversationLoaded(conversation));
    } catch (e) {
      emit(ChatError('Failed to get chat conversation: $e'));
    }
  }

  List<ChatMessageEntity> messages = [];

  Future<void> _onSendChatMessage(
    SendChatMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = await _sendChatMessageUseCase(
        SendChatMessageParams(
          requestId: event.requestId,
          messageType: event.messageType,
          message: event.message,
          attachments: event.attachments,
          quickActionType: event.quickActionType,
        ),
      );
      messages.add(message);
      emit(ChatMessageSent(message));
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }



  Future<void> _onGetAllConversations(
    GetAllConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversations = await _getAllConversationsUseCase(
        GetAllConversationsParams(status: event.status),
      );
      emit(ChatConversationListLoaded(conversations));
    } catch (e) {
      emit(ChatError('Failed to get conversations: $e'));
    }
  }


  void _onMarkMessageAsRead(
    MarkMessageAsReadEvent event,
    Emitter<ChatState> emit,
  ) {
    // This will be used to mark messages as read
    // Implementation depends on your specific requirements
  }

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();


  void initPusher(  InitializePusherEvent event,
      Emitter<ChatState> emit,)async{
    try {
      var pusherKey = "61549ed0a2c8e226e9be";
      var pusherCluster = "mt1";
      await pusher.init(
        apiKey: pusherKey,
        cluster: pusherCluster,
        onConnectionStateChange: (currentState, previousState) {
          print(' ConnectionState: $currentState');
        },
        onSubscriptionError: (message, error) {
          print('Subscription error: $message');
        },
        onSubscriptionSucceeded: (channelName, data) {
          print('Subscription succeeded: $channelName');
        },

        onEvent: (event){
          try{
            if(event.eventName == "message.sent"){
              var data = jsonDecode(event.data);
              var message = data["message"];
              print(message);
              var messageEntity = ChatMessageEntity(id: message["id"], senderType: message["sender"]["role"], senderName: message["sender"]["name"], isRead: message["is_read"], isSystem: message["sender"]["is_system"], type: message["type"], content: message["content"], file: message["file"], formattedTime: message["formatted_time"]);
              add(PusherMessageReceived(messageEntity)); // ✅ fire event, not emit

            }
          }catch(e){
            print('❌ Error handling Pusher event: $e');
          }
        },
      );
      await pusher.subscribe(channelName: 'transport-chat.${event
          .conversationId}');
      await pusher.connect();
    } catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  void disposePusher(
      DisposePusherEvent event,
      Emitter<ChatState> emit,
      )async{
    if(pusher.connectionState == "CONNECTED") {
      await pusher.disconnect();
    }
  }




  @override
  Future<void> close() {

    _pusherService.disconnect();
    return super.close();
  }
}
